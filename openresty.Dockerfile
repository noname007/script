FROM fedora:latest
MAINTAINER soul11201 "soul11201@gmail.com"

ADD systemtap systemtap

EXPOSE 80 7777 8888 9999

RUN \
    yum install -y make &&\
    ls -alh / &&\
    ls -alh systemtap &&\
    pwd &&\
    cd systemtap &&  \
    make openresty


