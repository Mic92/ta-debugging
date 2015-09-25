#include <unistd.h>
int mywd(char* wd){
  getwd(wd);
}
int main() {
  char *buf = (char*)1;
  int local = 2;
  mywd(buf);
}
