all: hello fork mount crash

hello: hello.s
	$(CC) $(CFLAGS) -nostdlib -o hello hello.s

fork: fork.c
	$(CC) $(CFLAGS) -o fork fork.c

mount: mount.c
	$(CC) $(CFLAGS) -o mount mount.c

crash: crash.c
	$(CC) $(CFLAGS) -o crash crash.c

clean:
	rm -f hello fork mount crash
