FROM ubuntu:latest

RUN apt-get clean
RUN apt-get update
RUN apt-get upgrade --fix-missing

RUN DEBIAN_FRONTEND=noninteractive apt install -y \
	gcc \
	make \
	binutils \
	build-essential \
	linux-source \
	nasm \
	zsh \
	curl \
	git \
	gdb \
	lldb \
	man \
	valgrind \
	vim \
	john \
	wget \
	openssh-server
	
WORKDIR /root
RUN mkdir shared

RUN /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN apt-get -y install git build-essential libssl-dev zlib1g-dev
RUN apt-get -y install yasm pkg-config libgmp-dev libpcap-dev libbz2-dev

RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt install -y python3-pip


WORKDIR /root
USER root
