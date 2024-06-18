CC=gcc-14

buildc:
	$(CC) -O3 -fopenmp c/coins.c -o coins-cpu

build-kernel:
	xcrun -sdk macosx metal -c objc/coin_kernel.metal -o coin_kernel.air
	xcrun -sdk macosx metallib coin_kernel.air -o coin_kernel.metallib

build-metal: build-kernel
	clang++ -framework Metal -framework Foundation -o coins-metal objc/coins.mm

clean:
	rm -f coins-cpu
	rm -f coins-metal
	rm -f coin_kernel.air
	rm -f coin_kernel.metallib

.PHONY: clean
