# Debugging Themenabend
Folien/Code vom Debugging-Themenabend am 25. September 2015 im [GCHQ](https://c3d2.de/news/ta-debugging.html)

**Work in Progress**

Abhängigkeiten installieren:

debian/ubuntu:

```bash
$ apt-get install libc6-dbg build-essential strace tcpdump sysdig gdb sysdig-dkms
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

## Ltrace

```
$ ltrace ls 2>&1 | less
$ ldd /usr/bin/ls
$ ltrace -e malloc ls | less
$ man 3 malloc
$ ltrace -e nginx -t -c ./nginx.conf | less
/OPENSSL_config
/strcmp
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
$ du -h ./hello
# add Debug flags
$ make clean && make CFLAGS=-g
$ du -h ./hello
$ gdb ./hello
(gdb) break hello.s:4
(gdb) run
(gdb) continue
(gdb) break hello.s:8
(gdb) info breakpoints
(gdb) info line *0x000000000040010c
(gdb) delete 1
(gdb) info breakpoints
(gdb) next
(gdb) <ENTER>
(gdb) <ENTER>
(gdb) <ENTER>
(gdb) ....
(gdb) info inferiors
$ strip ./hello
```

### Coredumps

```
$ systemd-nspawn -D /var/lib/lxc/base/rootfs
$ echo core | sudo tee /proc/sys/kernel/core_pattern
$ ulimit -c unlimited
$ gdb crash core.4036
(gdb) bt
$ ldd ./crash
$ apt-get install libc6-dbg
# https://packages.debian.org/de/wheezy/amd64/libc6-dbg/filelist
$ gdb crash core.4036
(gdb) bt
(gdb) up
(gdb) info locale
(gdb) down
```

### Rust

```
$ rustc -g -L . echoserver.rs
$ pacman -Ql rust | grep gdb
$ rust-gdb ./gdb
(gdb) info threads
$ break main
$ continue
Ctrl-C
$ bt
$ nc localhost 7777
$ info threads
$ b rust/echoserver.rs:20
$ b rust/echoserver.rs:24
$ thread 2
$ info locals
$ print buf
$ p /d sizeof(buf)
$ p /d count
$ p &buf
$ x/100 0x7ffff6ef87d0
$ x/100s 0x7ffff6ef87d0
```

### Go

```
$ cd go
$ go build .
$ gdb ./go
(gdb) b concurrency.go:14
(gdb) run
(gdb) source /usr/lib/go/src/runtime/runtime-gdb.py
(gdb) info locals
(gdb) watch *0xc82000a2b0
(gdb) info watchpoints
(gdb) continue
(gdb) continue
```

### Remote Server
```
$ cd ~/go/src/github.com/Mic92/gogopherd/gogopherd_linux_arm
$ adb shell
android> gdbserver 192.168.42.129:2345 /system/xbin/gogopherd /sdcard
$ arm-none-eabi-gdb
(gdb) file gogopherd
(gdb) target remote 192.168.42.129:2345
$ adb shell
android> telnet localhost 70
```

### Reverse Debugging

```
$ gdb ./crash
(gdb) b main
(gdb) run
(gdb) record full
(gdb) c
(gdb) bt
(gdb) reverse-next
(gdb) set exec-direction reverse
(gdb) next
```

### Peda

## LLDB

- bessere UI
- modernere Architektur
- weniger Plattformen
$ lldb ./crash

## /proc

```
$ /proc/self
$ ls -la cwd
$ ls -la exe
$ ls -la fd
$ exec 3> /tmp/foo
$ ls -la fd
$ less maps
$ less smaps
$ cat cgroup
$ less status
$ less environ
```

## tcpdump

```
$ tcpdump -i any -n port 6600 -A
$ modprobe usbmon
$ tcpdump --list-interfaces
$ tcpdump -i usbmon2 -XX
$ ss --numeric --processes --tcp
$ tcpdump -i eth0 host 172.23.75.15 -A -n
```

## sysdig

- http://www.sysdig.org/
- Kernelmodul (`modprobe sysdig-probe`)
- Kommandozeilenprogramm
- gute Unterstützung für Linuxcontainer
- Scriptbar (Luajit)
- Pcap-Ähnliche Filter

```
$ sysdig --list | less
$ sysdig 'proc.name=gdb and evt.type = ptrace'
$ sysdig -w sysdig.trace 'proc.name=go'
$ gdb ./go
(gdb) catch syscall exit_group
$ sysdig -r sysdig.trace
$ sysdig -r sysdig.trace evt.is_io=true
$ sysdig --list-chisels | less
$ sysdig -c spy_logs # auf dem Server
$ sysdig -c spy_user
$ sysdig -c proc_exec_time
$ make clean all
$ lxc-start -n base
$ sysdig -c lscontainers
$ lxc-attach -n base env - bash
$ lxc-stop -n base
$ sysdig container.name contains base -w container.trace
$ lxc-start -n base
$ sysdig -r container.trace evt.failed=true | less
```

## Kleine Helfer

```bash
# Binutils
$ nm -D /usr/lib/libboost_atomic.so
$ c++filt _ZN5boost7atomics6detail8lockpool11scoped_lockC1EPVKv
$ readelf <binary>
$ addr2line
$ objdump
```
