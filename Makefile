all: hello fork mount

hello: hello.s
	$(CC) -nostdlib -o hello hello.s

fork: fork.c
	$(CC) -o fork fork.c

mount: mount.c
	$(CC) -o mount mount.c

clean:
	rm -f hello fork mount
