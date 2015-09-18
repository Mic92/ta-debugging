# Debugging Themenabend
Folien/Code vom Debugging-Themenabend am 25. September 2015 im [GCHQ](https://c3d2.de/news/ta-debugging.html)

Abhängigkeiten installieren:

debian/ubuntu:

```
$ apt-get install build-essential strace tcpdump sysdig sysdig-dkms
```

archlinux:

```
$ pacman -S base-devel strace tcpdump sysdig
$ systemctl restart dkms
```

Beispiele bauen mit:

```
$ make
```
