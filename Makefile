CC=gcc-13

buildc:
	$(CC) -fopenmp c/coins.c -o coins

clean:
	rm -f coins

.PHONY: clean
