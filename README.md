# PwnEnv
A docker environment for pwn in ctf fork from [Pwndocker](https://github.com/skysider/pwndocker) and add some useful tools.

## Offline

```
# run the init.sh first before build images
cd pwnenv/offline
./init.sh
docker build -t pwnenv .

```



## Online

```
cd pwnenv/online
docker build -t pwnenv .
```



## Usage
```dockerfile
docker run -d \
    --rm \
    -h ${name} \
    --name ${name} \
    -v ${pwd}/${name}:/root/pwn \
    -p 23946:23946 \
    -p 9999:9999 \
    --privileged
    leeshunpeng/pwnenv

#port 23946 is for ida linux_server or linux_server64
#port 9999 is for socat

docker exec -it ${name} /bin/zsh
```

## Included software
- pwntools
- pwndbg
- Pwngdb
- gef
- peda
- ROPgadget
- ropper
- angr
- radare2
- one_gadget
- seccomp-tools
- tmux
- ltrace
- strace
- linux_server[64]
- zsh && oh-my-zsh
- libc-database
- LibcSearcher

## Add some command
- ida32 #run ida debug server linux_server on 23946
- ida64 #run ida debug server linux_server64 on 23946
- goGDB  #run gdb and select plugins in pwndbg / Pwngdb / peda / gef
- remote xxx  # socat tcp-listen:9999,reuseaddr,fork exec:/root/pwn/xxx,pty,raw,echo=0


## How to run in custom libc version?
```
cp /glibc/2.27/64/lib/ld-2.27.so /tmp/ld-2.27.so
patchelf --set-interpreter /tmp/ld-2.27.so ./test
LD_PRELOAD=./libc.so.6 ./test
```

or

```
from pwn import *
p = process(["/path/to/ld.so", "./test"], env={"LD_PRELOAD":"/path/to/libc.so.6"})
```

