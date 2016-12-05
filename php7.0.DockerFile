FROM soul11201/ubuntu
MAINTAINER soul11201 "soul11201@gmail.com"

RUN apt-get install -y software-properties-common python3-software-properties python-software-properties

RUN apt-add-repository -y ppa:ondrej/php
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
RUN apt-get update

RUN apt-get install -y php7.0 gcc make php7.0-dev


RUN apt-get install -y php7.0-gd php7.0-json php7.0-curl

RUN apt-get install -y git

RUN git clone git://github.com/phalcon/cphalcon.git  cphalcon && cd cphalcon/build && sudo ./install && cd .. && rm -rf cphalcon

RUN echo 'extension=phalcon.so' > /etc/php/7.0/cli/conf.d/30-phalcon.ini

RUN apt-get install -y php7.0-xdebug

ADD php.ini /etc/php/7.0/cli/php.ini

EXPOSE 80
EXPOSE 9000

RUN apt-get install -y php7.0-redis  php7.0-mysql
