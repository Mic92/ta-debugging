# Debugging Themenabend
Folien/Code vom Debugging-Themenabend am 25. September 2015 im [GCHQ](https://c3d2.de/news/ta-debugging.html)

**Work in Progress**

Abhängigkeiten installieren:

debian/ubuntu:

```bash
$ apt-get install build-essential strace tcpdump sysdig gdb sysdig-dkms
```

archlinux:

```bash
$ pacman -S base-devel strace tcpdump sysdig gdb
$ systemctl restart dkms
```

freebsd:
Gdb und tcpdump sind vorinstalliert, truss statt strace

Beispiele bauen mit:

```bash
$ make
```

[Peda](https://gitub.com/longld/peda) installieren:
```bash
$ git clone https://github.com/longld/peda ~/.peda
$ echo "source $HOME/.peda/peda.py" >> ~/.gdbinit
```

## Einleitung

- Debugging: Die Kunst des Verstehens
- Lernprozess

## Strace/Syscalls

- Auf x86: int 0x80
- Auf x86-64: syscall

Infos zu Systemaufrufen:

- ```<syscall>(<arg1>, <arg2>, <arg2>) = <returncode>```

```bash
$ strace ./hello
execve("./hello", ["./hello"], [/* 107 vars */]) = 0
write(1, "Hello World\n", 12)                    = 12
Hello World
_exit(0)                                         = ?
+++ exited with 0 +++
$ man 2 execve
$ man 2 write
$ strace -e clone -e write ./fork
$ strace -e trace=process ./fork
$ strace -f ./fork
$ strace -f -o /tmp/trace bash ./hello.sh
$ bash -x ./hello.sh
$ strace -e mount -f mount --bind . .
mount("/tmp/tmp.060KiO3KJg", "/tmp/tmp.060KiO3KJg", 0x820190, MS_MGC_VAL|MS_BIND, NULL) = 0
$ strace -f ./mount
$ touch Readme.md
$ sudo strace -f ./mount
$ man errno
$ strace nginx -c ./nginx.conf -p . # -> http://localhost:8082/README.md
$ strace -p $(pidof nginx)
```

## GDB

"Nicht schön, aber selten" (Unbekannter Autor):
  - Userinterface
  - Quellcode ```$ grep -A1 COPYRIGHT <(man gdb)```

```bash
$ gdb ./hello
(gdb) info target
(gdb) run
(gdb) break *0x000000000040010c
(gdb) continue
(gdb) run
$ make clean
# Debug flags
$ make CFLAGS=-g
$ gdb ./hello
(gdb) break hello.s:4
(gdb) continue
(gdb) break hello.s:8
(gdb) info breakpoints
(gdb) next
```

### Peda

## LLDB

"Schöner aber nicht ganz fertig"

## /proc

## tcpdump

## sysdig

## Kleine Helfer

```bash
# Binutils
$ strings <binary>
$ ldd <binary>
$ nm -D <binary>
$ readelf <binary>
$ addr2line
$ strip
$ objdump
$ c++filt
```
