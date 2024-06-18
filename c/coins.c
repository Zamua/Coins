#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>

unsigned long countSetBits(unsigned long n) {
  return __builtin_popcount(n);
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
        double start_time = omp_get_wtime();
        unsigned long long totalSequences = 1ULL << N;
        long aliceWins = 0, bobWins = 0, draws = 0;

        #pragma omp parallel for reduction(+:aliceWins, bobWins, draws)
        for (unsigned long long seq = 0; seq < totalSequences; seq++) {
            long alicePoints, bobPoints;
            countPoints(seq, &alicePoints, &bobPoints);

            if (alicePoints > bobPoints) {
                aliceWins++;
            } else if (bobPoints > alicePoints) {
                bobWins++;
            } else {
                draws++;
            }
        }

        double end_time = omp_get_wtime();
        double time_elapsed = end_time - start_time;

        printf("n=%d, time=%f, alice wins=%lu, bob wins=%lu, draws=%lu\n", N, time_elapsed, aliceWins, bobWins, draws);
    }

    return 0;
}

