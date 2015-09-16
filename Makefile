all: hello

hello: hello.s
	$(CC) -nostdlib -o hello hello.s

clean:
	rm -f hello
