PHP_PATH=/home/software/php7.0.14dd
OEPNRESTY_PATH=/home/software/openrestydd

prerequisites:
	yum install -y readline-devel pcre-devel openssl-devel gcc wget \
				icu libicu libicu-devel \
				autoconf libjpeg-dev libpng-dev libmcrypt-dev  bzip2 libbz2-dev curl libcurl4-gnutls-dev libfreetype6-dev  libxml2-devel gd-devel libmcrypt-devel libcurl-devel \
				libuuid-devel \



openresty: prerequisites
	test -f 'openresty-1.11.2.2.tar.gz' || wget https://openresty.org/download/openresty-1.11.2.2.tar.gz 
	test -d 'openresty-1.11.2.2' || tar -zxvf openresty-1.11.2.2.tar.gz 
	test -d $(OEPNRESTY_PATH) || (\
	 cd openresty-1.11.2.2 &&\
	./configure --prefix=$(OEPNRESTY_PATH) --with-pcre-jit --with-ipv6 --with-http_gzip_static_module    --with-http_stub_status_module -j2 &&\
	make -j2 &&\
	sudo make install &&\
	echo 'PATH=$(OEPNRESTY_PATH)/bin:$$PATH'>> ~/.bashrc && source ~/.bashrc  \
	)
lor: openresty
	test -d lor || git clone https://github.com/sumory/lor
	cd lor && sh install.sh
orange: lor
	test -d orange || git clone  https://github.com/sumory/orange.git 
	cd orange && ((git branch|grep 0.6.0) || git checkout -b   0.6.0 0.6.0) && make install

php7:
	test -f 'php-7.0.14.tar.gz' || wget http://cn2.php.net/distributions/php-7.0.14.tar.gz
	test -d php-7.0.14 || tar -zxvf php-7.0.14.tar.gz
	test -d $(PHP_PATH) || ( \
	cd php-7.0.14 &&\
	./configure --prefix=$(PHP_PATH)/ --with-gd --enable-gd-native-ttf --with-zlib --with-mcrypt  --enable-shmop --enable-sockets --enable-wddx --enable-zip --enable-fpm --enable-mbstring --with-zlib-dir --with-bz2 --with-curl --enable-exif  --with-iconv --enable-xml --enable-inline-optimization --enable-bcmath  --with-openssl --with-gettext  --enable-session --enable-fpm --enable-intl --enable-mbstring --enable-opcache  --with-pdo-mysql --enable-mysqlnd &&\
	make -j &&\
	make install && \
	cp php.ini-production $(PHP_PATH)/lib/php.ini  && \
	cp $(PHP_PATH)/etc/php-fpm.conf.default $(PHP_PATH)/etc/php-fpm.conf && \
	cp $(PHP_PATH)/etc/php-fpm.d/www.conf.default  $(PHP_PATH)/etc/php-fpm.d/www.conf && \
	echo "zend_extension=opcache.so" >>  $(PHP_PATH)/lib/php.ini && \
	echo 'export PATH=$(PHP_PATH)/bin/:$$PATH' >> ~/.bashrc && source ~/.bashrc \
	)

php7-ext-stomp: php7
	test -f 'stomp-2.0.0.tgz'||wget https://pecl.php.net/get/stomp-2.0.0.tgz
	test -d 'stomp-2.0.0' || tar -zxvf stomp-2.0.0.tgz
	source ~/.bashrc && \
	cd stomp-2.0.0 && \
	phpize && ./configure && make && make install && \
	echo "extension=stomp.so" >> $(PHP_PATH)/lib/php.ini

php7-ext-redis: php7
	test -f "redis.3.0.0.tar.gz" || wget https://github.com/phpredis/phpredis/archive/3.0.0.tar.gz  -O redis.3.0.0.tar.gz
	test -d "phpredis-3.0.0" || tar -zxvf  redis.3.0.0.tar.gz
	source ~/.bashrc && \
	cd phpredis-3.0.0 &&\
	phpize && ./configure && make && make install && \
	echo "extension=redis.so" >> $(PHP_PATH)/lib/php.ini

php7-ext-phalcon: php7
	test -d "cphalcon"|| git clone git://github.com/phalcon/cphalcon.git
	source ~/.bashrc &&\
	echo $$PATH && \
	cd cphalcon/build && \
	./install && \
	echo "extension=phalcon.so"   >> $(PHP_PATH)/lib/php.ini

install: prerequisites openresty php7 php7-ext-stomp php7-ext-redis php7-ext-phalcon