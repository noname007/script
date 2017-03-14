
SOFTWARE_PATH ?= $(HOME)/software

PHP_PATH ?= $(SOFTWARE_PATH)/php7.0.14dd
OEPNRESTY_PATH ?= $(SOFTWARE_PATH)/openrestydd
ORANGE_PATH ?= $(SOFTWARE_PATH)/orangedd

export $$PATH := $(PHP_PATH)/bin:$$PATH
export $$PATH := $(OEPNRESTY_PATH)/bin:$$PATH

prerequisites:prerequisites-yum

prerequisites-yum:
	mkdir -p $(SOFTWARE_PATH)
	sudo yum install -y  \
				readline-devel \
				pcre-devel \
				openssl-devel \
				gcc \
				wget \
				icu libicu libicu-devel \
				autoconf \
				bzip2 \
				curl \
				libxml2-devel \
				gd-devel \
				libmcrypt-devel \
				libcurl-devel\
				libuuid-devel \
				bzip2-devel \
				gcc-c++ \
				git \
				patch  \
				
				# libbz2-dev \
				# libfreetype6-dev \
				# libcurl4-gnutls-dev 
				# libpng-dev 
				# libmcrypt-dev 
				# libjpeg-dev


fedora-systemtap:prerequisites
	sudo yum install systemtap systemtap-runtime kernel-devel yum-utils
	sudo debuginfo-install kernel


prerequisites-ubuntu:
	mkdir -p  $(SOFTWARE_PATH)
	# @echo $$PATH
	@sudo apt-get  install -y gdb libtool libxml2-dev pkg-config libssl-dev libbz2-dev libfreetype6-dev libmcrypt-dev  curl wget  libcurl4-gnutls-dev libicu-dev libpcre3 libpcre3-dev zlib1g-dev libssl-dev build-essential bash-completion autoconf cmake git uuid-dev
#	选no, 使用 bash 否则无法使用source
	sudo dpkg-reconfigure  dash 

openresty: prerequisites
	test -f 'openresty-1.11.2.2.tar.gz' || wget https://openresty.org/download/openresty-1.11.2.2.tar.gz 
	test -d 'openresty-1.11.2.2' || tar -zxvf openresty-1.11.2.2.tar.gz 
	test -d $(OEPNRESTY_PATH) || (\
	cd openresty-1.11.2.2 &&\
	./configure --prefix=$(OEPNRESTY_PATH) --with-debug --with-pcre-jit --with-ipv6 --with-http_gzip_static_module    --with-http_stub_status_module  --with-http_ssl_module --with-http_realip_module -j2 &&\
	make -j2 &&\
	sudo make install &&\
	sudo sh -c 'echo PATH=$(OEPNRESTY_PATH)/bin:$$PATH >> /etc/profile.d/gateway.sh && source /etc/profile.d/gateway.sh' \
	)
# --with-http_ssl_module --with-http_realip_module --with-google_perftools_module --with-http_upstream_check_module --with-http_concat_module

lor: openresty
	test -d lor || git clone https://github.com/thisverygoodhhhh/lor.git
	cd lor && git pull && \
	sudo make install
orange: lor
	test -d $(ORANGE_PATH) || git clone  https://github.com/thisverygoodhhhh/orange.git $(ORANGE_PATH)
	cd $(ORANGE_PATH) && git checkout master

php7:
	test -f 'php-7.0.14.tar.gz' || wget http://cn2.php.net/distributions/php-7.0.14.tar.gz
	test -d php-7.0.14 || tar -zxvf php-7.0.14.tar.gz
	test -d $(PHP_PATH) || ( \
	cd php-7.0.14 &&\
	./configure --prefix=$(PHP_PATH)/ --with-gd --enable-gd-native-ttf --with-zlib --with-mcrypt  --enable-shmop --enable-sockets --enable-wddx --enable-zip --enable-fpm --enable-mbstring --with-zlib-dir --with-bz2 --with-curl --enable-exif  --with-iconv --enable-xml --enable-inline-optimization --enable-bcmath  --with-openssl --with-gettext  --enable-session --enable-fpm --enable-intl --enable-mbstring --enable-opcache  --with-pdo-mysql --enable-mysqlnd &&\
	make  &&\
	make install && \
	cp php.ini-production $(PHP_PATH)/lib/php.ini  && \
	cp $(PHP_PATH)/etc/php-fpm.conf.default $(PHP_PATH)/etc/php-fpm.conf && \
	cp $(PHP_PATH)/etc/php-fpm.d/www.conf.default  $(PHP_PATH)/etc/php-fpm.d/www.conf && \
	echo "zend_extension=opcache.so" >>  $(PHP_PATH)/lib/php.ini && \
	echo 'export PATH=$(PHP_PATH)/bin/:$$PATH' >> ~/.bashrc && source ~/.bashrc \
	)

php7-ext-stomp: php7
	test -f 'stomp-2.0.0.tgz'||wget https://pecl.php.net/get/stomp-2.0.0.tgz
	test -d 'stomp-2.0.0' || tar -zxvf stomp-2.0.0.tgz && \
	source ~/.bashrc && \
	cd stomp-2.0.0 && \
	phpize && ./configure && make && make install && \
	echo "extension=stomp.so" >> $(PHP_PATH)/lib/php.ini

php7-ext-redis: php7
	test -f "redis.3.0.0.tar.gz" || wget https://github.com/phpredis/phpredis/archive/3.0.0.tar.gz  -O redis.3.0.0.tar.gz
	test -d "phpredis-3.0.0" || tar -zxvf  redis.3.0.0.tar.gz && \
	source ~/.bashrc && \
	cd phpredis-3.0.0 &&\
	phpize && ./configure && make && make install && \
	echo "extension=redis.so" >> $(PHP_PATH)/lib/php.ini

php7-ext-phalcon: php7
	test -d "cphalcon"|| git clone git://github.com/thisverygoodhhhh/cphalcon.git && \
	source ~/.bashrc &&\
	echo $$PATH && \
	cd cphalcon/build && \
	./install && \
	echo "extension=phalcon.so"   >> $(PHP_PATH)/lib/php.ini

php-composer:
	test -d "composer.phar" || wget https://getcomposer.org/download/1.3.2/composer.phar
	chmod +x composer.phar 
	cp composer.phar /bin/composer
	mv composer.phar /usr/local/bin/composer
	composer config -g repo.packagist composer https://packagist.phpcomposer.com
	composer



php-amqp: librabbitmq
	test -d "amqp-1.7.1.tgz"||test -d "amqp-1.7.1" ||  wget https://pecl.php.net/get/amqp-1.7.1.tgz
	test -d "amqp-1.7.1" ||( tar -zxvf amqp-1.7.1.tgz  &&\
	cd amqp-1.7.1 && \
	phpize  && \
	./configure --with-amqp --with-librabbitmq-dir=/usr/local/ && \
	make && \
	make install &&  \
	echo "extension=amqp.so"   >> $(PHP_PATH)/lib/php.ini && \
	make test )\

librabbitmq:
	test -d "rabbitmq-c" || (git clone https://github.com/alanxz/rabbitmq-c.git && \
	cd rabbitmq-c/ && \
	git submodule init && \
	git submodule update && \
	git checkout -b v0.8.0 v0.8.0 && \
	autoreconf -i && \
	./configure && \
	mkdir build && cd build && \
	cmake .. && \
	sudo cmake --build .  --target install  &&\
	sudo sh -c 'echo "/usr/local/lib/x86_64-linux-gnu"  >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf' &&\
	ldconfig \
	)\

wrk: prerequisites
	git clone https://github.com/wg/wrk.git
	cd wrk && \
	make && \
	sudo cp wrk /bin
	wrk

install-all: prerequisites openresty orange php7 php7-ext-stomp php7-ext-redis php7-ext-phalcon php-amqp php-composer


update-orange: orange
	cd $(ORANGE_PATH) && git checkout master && git pull origin master

update-lor: lor
