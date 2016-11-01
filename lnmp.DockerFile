FROM ubuntu:14.04
MAINTAINER soul11201 "soul11201@gmail.com"
RUN apt-get update
RUN apt-get install -y nginx
RUN echo 'Hi, I am in your container'  > /usr/share/nginx/html/index.html

RUN apt-get install -y php5-dev libpcre3-dev gcc make php5-mysql php5-fpm php5-cli
RUN apt-get install -y git
RUN git clone git://github.com/phalcon/cphalcon.git  cphalcon\
	cd cphalcon/build \
	sudo ./install \
	cd .. \
	rm -rf cphalcon \

RUN echo 'extension=phalcon.so' > /etc/php5/fpm/conf.d/30-phalcon.ini \
	echo 'extension=phalcon.so' > /etc/php5/cli/conf.d/30-phalcon.ini

ENTRYPOINT ['/usr/sbin/nginx',"-g",'daemon off;']
ENTRYPOINT ['/usr/sbin/php5-fpm']
EXPOSE 80