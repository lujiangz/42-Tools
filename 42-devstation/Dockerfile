FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean && apt-get update && apt-get install -y \
    gcc make binutils build-essential linux-source \
    nasm zsh curl git gdb lldb man valgrind vim nano \
    dirb nmap john wget sudo openssh-server strace ltrace \
    htop hydra netcat-openbsd tcpdump sqlmap tree net-tools \
    nethogs software-properties-common \
    libssl-dev zlib1g-dev yasm pkg-config libgmp-dev \
    libpcap-dev libbz2-dev \
    python3 python3-pip python3-venv \
    unzip xz-utils lsof \
    tmux screen \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN sed -i 's/ZSH_THEME=".*"/ZSH_THEME="robbyrussell"/' ~/.zshrc && \
    echo '\
alias ll="ls -alF"\n\
alias la="ls -A"\n\
alias l="ls -CF"\n\
alias py="python3"\n\
alias please="sudo"\n\
' >> ~/.zshrc

WORKDIR /root
RUN mkdir shared

USER root
