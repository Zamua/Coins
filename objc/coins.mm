#include <Foundation/Foundation.h>
#include <Metal/Metal.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Struct to hold Metal setup data
typedef struct {
    id<MTLDevice> device;
    id<MTLCommandQueue> commandQueue;
    id<MTLComputePipelineState> pipelineState;
} MetalSetup;

// Function prototypes
unsigned long long sum(unsigned long long *nums, NSUInteger nums_len);
void runKernel(MetalSetup metalSetup, int N);
void initializeBuffers(id<MTLDevice> device, NSUInteger threadGroupSize, unsigned long long totalSequences, id<MTLBuffer> *totalAliceWinsBuffer, id<MTLBuffer> *totalBobWinsBuffer, id<MTLBuffer> *totalDrawsBuffer, id<MTLBuffer> *totalSequencesBuffer);
MetalSetup setupMetal();

int main() {
    @autoreleasepool {
        MetalSetup metalSetup = setupMetal();
        if (!metalSetup.device || !metalSetup.commandQueue || !metalSetup.pipelineState) {
            NSLog(@"Failed to set up Metal");
            return -1;
        }

        for (int N = 2; ; N++) {
            runKernel(metalSetup, N);
        }
    }

    return 0;
}

unsigned long long sum(unsigned long long *nums, NSUInteger nums_len) {
    unsigned long long sum = 0;

    for (NSUInteger i = 0; i < nums_len; i++) {
        sum += nums[i];
    }

    return sum;
}

void runKernel(MetalSetup metalSetup, int N) {
    unsigned long long totalSequences = 1ULL << N;
    NSUInteger threadGroupSize = metalSetup.pipelineState.maxTotalThreadsPerThreadgroup;
    if (threadGroupSize > totalSequences) {
        threadGroupSize = totalSequences;
    }

    id<MTLBuffer> totalAliceWinsBuffer, totalBobWinsBuffer, totalDrawsBuffer, totalSequencesBuffer;
    initializeBuffers(metalSetup.device, threadGroupSize, totalSequences, &totalAliceWinsBuffer, &totalBobWinsBuffer, &totalDrawsBuffer, &totalSequencesBuffer);

    // Start the timer
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    id<MTLCommandBuffer> commandBuffer = [metalSetup.commandQueue commandBuffer];
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    [computeEncoder setComputePipelineState:metalSetup.pipelineState];
    [computeEncoder setBuffer:totalAliceWinsBuffer offset:0 atIndex:1];
    [computeEncoder setBuffer:totalBobWinsBuffer offset:0 atIndex:2];
    [computeEncoder setBuffer:totalDrawsBuffer offset:0 atIndex:3];
    [computeEncoder setBuffer:totalSequencesBuffer offset:0 atIndex:4];

    MTLSize threadgroupSize = MTLSizeMake(1, 1, 1);
    MTLSize gridSize = MTLSizeMake(threadGroupSize, 1, 1);
    [computeEncoder dispatchThreads:gridSize threadsPerThreadgroup:threadgroupSize];

    [computeEncoder endEncoding];
    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];

    // Stop the timer
    clock_gettime(CLOCK_MONOTONIC, &end);
    double time_taken = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;

    unsigned long long *aliceWins = (unsigned long long *)totalAliceWinsBuffer.contents;
    unsigned long long *bobWins = (unsigned long long *)totalBobWinsBuffer.contents;
    unsigned long long *draws = (unsigned long long *)totalDrawsBuffer.contents;

    unsigned long long totalAliceWins = sum(aliceWins, threadGroupSize);
    unsigned long long totalBobWins = sum(bobWins, threadGroupSize);
    unsigned long long totalDraws = sum(draws, threadGroupSize);

    printf("n=%d, time=%.6f, alice wins=%llu, bob wins=%llu, draws=%llu\n", N, time_taken, totalAliceWins, totalBobWins, totalDraws);
}

void initializeBuffers(id<MTLDevice> device, NSUInteger threadGroupSize, unsigned long long totalSequences, id<MTLBuffer> *totalAliceWinsBuffer, id<MTLBuffer> *totalBobWinsBuffer, id<MTLBuffer> *totalDrawsBuffer, id<MTLBuffer> *totalSequencesBuffer) {
    *totalAliceWinsBuffer = [device newBufferWithLength:sizeof(unsigned long long) * threadGroupSize options:MTLResourceStorageModeShared];
    *totalBobWinsBuffer = [device newBufferWithLength:sizeof(unsigned long long) * threadGroupSize options:MTLResourceStorageModeShared];
    *totalDrawsBuffer = [device newBufferWithLength:sizeof(unsigned long long) * threadGroupSize options:MTLResourceStorageModeShared];
    *totalSequencesBuffer = [device newBufferWithBytes:&totalSequences length:sizeof(totalSequences) options:MTLResourceStorageModeShared];

    memset((*totalAliceWinsBuffer).contents, 0, sizeof(unsigned long long) * threadGroupSize);
    memset((*totalBobWinsBuffer).contents, 0, sizeof(unsigned long long) * threadGroupSize);
    memset((*totalDrawsBuffer).contents, 0, sizeof(unsigned long long) * threadGroupSize);
}

MetalSetup setupMetal() {
    MetalSetup metalSetup;
    metalSetup.device = nil;
    metalSetup.commandQueue = nil;
    metalSetup.pipelineState = nil;

    NSError *error = nil;
    NSArray<id<MTLDevice>> *devices = MTLCopyAllDevices();
    metalSetup.device = [devices firstObject];
    metalSetup.commandQueue = [metalSetup.device newCommandQueue];

    NSString *libraryPath = [[NSBundle mainBundle] pathForResource:@"coin_kernel" ofType:@"metallib"];
    NSURL *libraryURL = [NSURL fileURLWithPath:libraryPath];
    id<MTLLibrary> library = [metalSetup.device newLibraryWithURL:libraryURL error:&error];

    if (error) {
        NSLog(@"Failed to create library: %@", error);
        return metalSetup;
    }

    id<MTLFunction> kernelFunction = [library newFunctionWithName:@"countPointsKernel"];
    if (!kernelFunction) {
        NSLog(@"Failed to create function");
        return metalSetup;
    }

    metalSetup.pipelineState = [metalSetup.device newComputePipelineStateWithFunction:kernelFunction error:&error];
    if (error) {
        NSLog(@"Failed to create pipeline state: %@", error);
        return metalSetup;
    }

    return metalSetup;
}
