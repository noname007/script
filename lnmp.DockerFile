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
RUN apt-get install -y nginx
RUN echo 'Hi, I am in your container'  > /usr/share/nginx/html/index.html

RUN apt-get install -y php5-dev libpcre3-dev gcc make php5-mysql php5-fpm php5-cli
RUN apt-get install -y git
RUN git clone git://github.com/phalcon/cphalcon.git  cphalcon && cd cphalcon/build && sudo ./install && cd .. && rm -rf cphalcon 

RUN echo 'extension=phalcon.so' > /etc/php5/fpm/conf.d/30-phalcon.ini && echo 'extension=phalcon.so' > /etc/php5/cli/conf.d/30-phalcon.ini


