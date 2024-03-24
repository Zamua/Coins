#include <stdio.h>
#include <stdlib.h>
#include <time.h>

long hammingWeights(unsigned long n) {
    n -= (n >> 1) & 0x5555555555555555L;
    n = (n & 0x3333333333333333L) + ((n >> 2) & 0x3333333333333333L);
    n = (n + (n >> 4)) & 0x0f0f0f0f0f0f0f0fL;
    n += n >> 8;
    n += n >> 16;
    n += n >> 32;
    return n & 0x7f;
}

long countSetBits(unsigned long n) {
  return hammingWeights(n);
}

// Function to count occurrences of "HH" (00) and "HT" (01)
void countPoints(unsigned long long sequence, long *alicePoints, long *bobPoints) {
    unsigned long long aliceMask = sequence & (sequence >> 1);
    unsigned long long bobMask = ~sequence & (sequence >> 1);

    *alicePoints = countSetBits(aliceMask);
    *bobPoints = countSetBits(bobMask);
}

int main() {
    for (int N = 2; ; N++) {
        clock_t start = clock();
        unsigned long long totalSequences = 1ULL << N;
        long aliceWins = 0, bobWins = 0, draws = 0;

        for (unsigned long long seq = 0; seq < totalSequences; seq++) {
            long alicePoints, bobPoints;
            countPoints(seq, &alicePoints, &bobPoints);

            if (alicePoints > bobPoints) aliceWins++;
            else if (bobPoints > alicePoints) bobWins++;
            else draws++;
        }

        clock_t end = clock();
        double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
        printf("n=%d, time=%f, alice wins=%lu, bob wins=%lu, draws=%lu\n", N, cpu_time_used, aliceWins, bobWins, draws);
    }

    return 0;
}

