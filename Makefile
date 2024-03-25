CC=gcc-13

buildc:
	$(CC) -O3 -fopenmp c/coins.c -o coins

clean:
	rm -f coins

.PHONY: clean
