#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>

int countSetBits(unsigned long long n) {
  return __builtin_popcountll(n);
}

// Function to count occurrences of "HH" (00) and "HT" (01)
void countPoints(unsigned long long sequence, int *alicePoints, int *bobPoints) {
    unsigned long long aliceMask = sequence & (sequence >> 1);
    unsigned long long bobMask = ~sequence & (sequence >> 1);

    *alicePoints = countSetBits(aliceMask);
    *bobPoints = countSetBits(bobMask);
}

int main() {
    for (int N = 2; ; N++) {
        double start_time = omp_get_wtime();
        unsigned long long totalSequences = 1ULL << N;
        unsigned long long aliceWins = 0, bobWins = 0, draws = 0;

        #pragma omp parallel for reduction(+:aliceWins, bobWins, draws)
        for (unsigned long long seq = 0; seq < totalSequences; seq++) {
            int alicePoints, bobPoints;
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

        printf("n=%d, time=%f, alice wins=%llu, bob wins=%llu, draws=%llu\n", N, time_elapsed, aliceWins, bobWins, draws);
    }

    return 0;
}

