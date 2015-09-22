#include <stdio.h>
#include <sys/mount.h>

int main() {
	if (mount("README.md", "Readme.md", "none", MS_BIND, NULL) != 0) {
		perror("cannot mount");
	};
}
