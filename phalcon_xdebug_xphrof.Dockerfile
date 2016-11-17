FROM soul11201/phalcon
MAINTAINER soul11201 "soul11201@gmail.com"
RUN apt-get install -y php5-xdebug
ADD php.ini /etc/php5/php.ini

EXPOSE 9000