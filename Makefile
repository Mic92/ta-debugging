all: hello fork mount

hello: hello.s
	$(CC) $(CFLAGS) -nostdlib -o hello hello.s

fork: fork.c
	$(CC) $(CFLAGS) -o fork fork.c

mount: mount.c
	$(CC) $(CFLAGS) -o mount mount.c

clean:
	rm -f hello fork mount
