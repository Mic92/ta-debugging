all: hello fork

hello: hello.s
	$(CC) -nostdlib -o hello hello.s

fork: fork.c
	$(CC) -o fork fork.c

clean:
	rm -f hello fork
