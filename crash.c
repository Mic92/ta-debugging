#include <unistd.h>
int main() {
  char *buf = (char*)1;
  getwd(buf);
}
