# Debugging Themenabend
Folien/Code vom Debugging-Themenabend am 25. September 2015 im [GCHQ](https://c3d2.de/news/ta-debugging.html)

Abhängigkeiten installieren:

debian/ubuntu:

```
$ apt-get install build-essential strace tcpdump sysdig gdb sysdig-dkms
```

archlinux:

```
$ pacman -S base-devel strace tcpdump sysdig gdb
$ systemctl restart dkms
```

Beispiele bauen mit:

```
$ make
```

## Strace/Syscalls

Infos zu Systemaufrufen:

```
$ strace ./hello
execve("./hello", ["./hello"], [/* 107 vars */]) = 0
write(1, "Hello World\n", 12Hello World
)           = 12
_exit(0)                                = ?
+++ exited with 0 +++
$ man 2 execve
$ man 2 write
$ strace -e clone -e write ./fork
$ strace -e trace=process ./fork
$ strace -f ./fork
$ strace bash ./hello.sh
$ bash -x ./hello.sh
$ strace nginx -c ./nginx.conf -p . # -> http://localhost:8082/README.md
```

## GDB

```
```

[Peda](https://gitub.com/longld/peda) installieren:
```
git clone https://github.com/longld/peda ~/.peda
echo "source $HOME/.peda/peda.py" >> ~/.gdbinit
```
