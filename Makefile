CC=gcc

# Define the build target
buildc:
	$(CC) c/coins.c -o coins

# Define a clean rule
clean:
	rm -f $(TARGET)

.PHONY: clean

