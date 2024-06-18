#include <metal_stdlib>
using namespace metal;

kernel void countPointsKernel(
    device ulong* totalAliceWins [[buffer(1)]],
    device ulong* totalBobWins [[buffer(2)]],
    device ulong* totalDraws [[buffer(3)]],
    device ulong* totalSequences [[buffer(4)]],
    uint id [[thread_position_in_grid]],
    uint numThreads [[threads_per_grid]]
) {
    // Get the total number of sequences
    ulong N = totalSequences[0];

    // Calculate the range size and start/end indices for each thread
    ulong rangeSize = (N + numThreads - 1) / numThreads; // Ensure each thread processes an even chunk
    ulong startIndex = id * rangeSize;
    ulong endIndex = min(startIndex + rangeSize, N);

    // Initialize local counters
    ulong localAliceWins = 0, localBobWins = 0, localDraws = 0;

    // Compute points for the assigned range
    for (ulong sequence = startIndex; sequence < endIndex; ++sequence) {
        ulong aliceMask = sequence & (sequence >> 1);
        ulong bobMask = ~sequence & (sequence >> 1);

        int alicePoints = popcount(aliceMask);
        int bobPoints = popcount(bobMask);

        if (alicePoints > bobPoints) {
            localAliceWins++;
        } else if (bobPoints > alicePoints) {
            localBobWins++;
        } else {
            localDraws++;
        }
    }

    // Write the local results to the output buffers
    totalAliceWins[id] = localAliceWins;
    totalBobWins[id] = localBobWins;
    totalDraws[id] = localDraws;
}
