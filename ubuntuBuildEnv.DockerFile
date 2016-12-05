FROM ubuntu:14.04
MAINTAINER soul11201 "soul11201@gmail.com"

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse" >> /etc/apt/sources.list.d/ali.mirror.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list.d/ali.mirror.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list.d/ali.mirror.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list.d/ali.mirror.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list.d/ali.mirror.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse" >> /etc/apt/sources.list.d/ali.mirror.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list.d/ali.mirror.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list.d/ali.mirror.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list.d/ali.mirror.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list.d/ali.mirror.list

RUN apt-get update

RUN apt-get install -y make
RUN apt-get install -y gcc bash-completion git vim

RUN apt-get install -y libxml2-dev build-essential openssl libssl-dev curl libcurl4-gnutls-dev libjpeg-dev libpng-dev libmcrypt-dev libreadline6 libreadline6-dev

RUN apt-get install -y  autoconf automake libtool cmake

RUN apt-get install -y re2c flex bison

RUN apt-get  install -y tree

