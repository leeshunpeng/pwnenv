FROM phusion/baseimage:master-amd64
MAINTAINER 0x88 <leeshunpeng@163.com>

COPY tools /root/tools

RUN mkdir /root/.pip && mv /root/tools/pip.conf /root/.pip/pip.conf \
    && mv /root/tools/sources.list /etc/apt/sources.list \
    && mv /root/tools/tmux.conf /root/.tmux.conf

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get install -y \
    libc6:i386 \
    libc6-dev \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    gcc-multilib \
    g++-multilib \
    cmake \
    ipython3 \
    vim \
    net-tools \
    iputils-ping \
    libffi-dev \
    libssl-dev \
    python3 \
    python3-dev \
    python3-pip \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    radare2 \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file \
    zsh \
    autojump \
    autoconf \
    python3-distutils \
    bison --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    ropgadget \
    pwntools \
    z3-solver \
    smmap2 \
    apscheduler \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    angr \
    pebble

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

RUN chmod +x /root/tools/goGDB && ln -s /root/tools/goGDB /usr/bin/goGDB \
    && chmod +x /root/tools/linux_server* \
    && chmod +x /root/tools/pwndbg/setup.sh && cd /root/tools/pwndbg && ./setup.sh \
    && cd /root/tools/welpwn && python3 setup.py install \
    && ln -s /root/tools/libc-database /root/tools/LibcSearcher/libc-database && cd /root/tools/LibcSearcher && python3 setup.py develop \
    && mv /root/tools/oh-my-zsh /root/.oh-my-zsh && cp /root/.oh-my-zsh/templates/zshrc.zsh-template /root/.zshrc \
    && chsh -s $(which zsh) \
    && mv /root/tools/zsh-syntax-highlighting /root/.oh-my-zsh/custom/plugins \
    && mv /root/tools/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins \
    && sed -i 's/plugins=(git)/plugins=(git autojump zsh-autosuggestions zsh-syntax-highlighting)/' /root/.zshrc \
    && echo "source /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /root/.zshrc \
    && rm -rf /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python \
    && echo 'alias ida32=/root/tools/linux_server' >> /root/.zshrc \
    && echo 'alias ida64=/root/tools/linux_server64' >> /root/.zshrc \
    && echo 'alias gdb=goGDB' >> /root/.zshrc \
    && echo 'function remote(){socat tcp-listen:9999,reuseaddr,fork exec:/root/pwn/"$1",pty,raw,echo=0}' >> /root/.zshrc \
    && echo "/root/tools/libc-database" > /root/.libcdb_path

RUN python3 -m pip install --no-cache-dir \
    six==1.14.0 \
    unicorn==1.0.2rc1 \
    decorator==4.3.0

WORKDIR /root/pwn

CMD ["/sbin/my_init"]
