#include <sys/wait.h>
#include <stdio.h>
#include <unistd.h>

int main() {
	switch (fork()) {
		case -1:
			perror("cannot fork");
		case 0:
			printf("I am the child\n");
		default:
			puts("I am the parent");
			wait(NULL);
	}
	return 0;
}
