
SOFTWARE_PATH ?= $(HOME)/data

OEPNRESTY_PATH ?= $(SOFTWARE_PATH)/software/openrestydd
ORANGE_PATH ?= $(SOFTWARE_PATH)/software/orangedd
SYSTEMTAP_PATH ?= $(SOFTWARE_PATH)/software/stap
FLAMEGRAPH_PATH ?= $(SOFTWARE_PATH)/FlameGraph
BUILD_PATH?=$(SOFTWARE_PATH)/build

SYSTEMTAP_VERSION ?= 3.1

PHP_VERSION ?= 7.0.22
PHP_AMQP_VERSION ?= 1.7.1
PHP_SWOOLE_VERSION ?=2.0.7

PHP_PATH ?= $(SOFTWARE_PATH)/software/php/$(PHP_VERSION)

OEPNRESTY_VERSION ?= 1.13.6.1

OPENSSL_VERSION?=1.0.2k
PCRE_VERSION?=8.39

export $$PATH := $(PHP_PATH)/bin:$$PATH
export $$PATH := $(OEPNRESTY_PATH)/bin:$$PATH

.ONESHELL:
echo:
	echo $$PATH
	@echo SOFTWARE_PATH 	  "---------" $(SOFTWARE_PATH)
	@echo PHP_PATH 			  "---------" $(PHP_PATH)
	@echo OEPNRESTY_PATH 	  "---------" $(OEPNRESTY_PATH)
	@echo ORANGE_PATH 		  "---------" $(ORANGE_PATH)
	@echo SYSTEMTAP_PATH 	  "---------" $(SYSTEMTAP_PATH)
	@echo FLAMEGRAPH_PATH 	  "---------" $(FLAMEGRAPH_PATH)
	@echo SYSTEMTAP_VERSION   "---------" $(SYSTEMTAP_VERSION)
	@echo BUILD_PATH 		  "---------" $(BUILD_PATH)
	@echo PHP_VERSION 		  "---------" $(PHP_VERSION)
	@echo PHP_AMQP_VERSION 	  "---------" $(PHP_AMQP_VERSION)


prerequisites:
	mkdir -p $(SOFTWARE_PATH)
	mkdir -p $(BUILD_PATH)
	chmod -R 777 $(BUILD_PATH)

prerequisites-yum:prerequisites
	yum upgrade
	yum install -y  \
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
				libuuid-devel                                 \
				bzip2-devel \
				gcc-c++ \
				git \
				patch  \
				htop \
				libtool \
				cmake \
				vim \
				make \
				ntpdate \
				# libbz2-dev \
				# libfreetype6-dev \
				# libcurl4-gnutls-dev 
				# libpng-dev 
				# libmcrypt-dev 
				# libjpeg-dev
	# ntpdate time.nist.gov
yum-shell:
	yum install -y curl zsh fish
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

deb-shell:
	apt-get install -y curl zsh fish
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


fedora-systemtap:prerequisites
	yum install -y systemtap systemtap-runtime kernel-devel yum-utils  
	debuginfo-install -y kernel

fedora-desktop:update-hosts
	yum install chromium

check-systemtap:
	@echo '=================================== In Ubuntu 16.04 ========================================================================================='
	@echo "exce:                    source /etc/profile.d/devops.sh                              "
	@echo "dbgsym:     http://ddebs.ubuntu.com/pool/main/l/linux/?C=M;O=D                        "
	@echo '============================================================================================================================'
	stap -ve 'probe begin { log("hello world") exit () }' 
	stap -c df -e 'probe syscall.* { if (target()==pid()) log(name." ".argstr) }' 
	gcc -g -O2 system-check.c  -o a.out 
	stap -e 'probe process("./a.out").function("main") { printf("hello\n"); }' -c "./a.out" 
	# stap -d /bin/ls --ldd -e 'probe process("ls").function("xmalloc") {print_usyms(ubacktrace())}' -c "ls /"


update-hosts:
	wget https://raw.githubusercontent.com/racaljk/hosts/master/hosts -O /etc/hosts



prerequisites-ubuntu:prerequisites
	mkdir -p  $(SOFTWARE_PATH)
	# @echo $$PATH
	@apt-get  install -y \
				gdb    \
				libtool    \
				libxml2-dev    \
				pkg-config    \
				libssl-dev    \
				libbz2-dev    \
				libfreetype6-dev    \
				libmcrypt-dev    \
				curl    \
				wget    \
				libcurl4-gnutls-dev    \
				libicu-dev    \
				libpcre3    \
				libpcre3-dev    \
				zlib1g-dev    \
				libssl-dev    \
				build-essential    \
				bash-completion    \
				autoconf    \
				cmake    \
				git    \
				uuid-dev    \
				vim \
				make \
				ntpdate \
				gettext
#	选no,使用bash 否则无法使用source
	dpkg-reconfigure  dash 
	# ntpdate time.nist.gov


unbutu-systemtap-depdency:prerequisites-ubuntu
	apt-get install -y linux-image-`uname -r`\* linux-headers-`uname -r` 
	apt-get install -y \
			libavahi-client-dev \
			libelf-dev \
			libnspr4-dev \
			libnss3-dev \
			libnss3-tools \
			pkg-config \
			texlive-fonts-recommended \
			texlive-latex-base \
			texlive-latex-extra \
			texlive-latex-recommended \
			gettext \
			elfutils \
			libdw-dev \

deb-systemtap:unbutu-systemtap-depdency systemtap-install

prerequisites-mac:
	brew install libjpeg
	brew install libpng
	brew install libmcrypt

systemtap-install:
	test -f systemtap-$(SYSTEMTAP_VERSION).tar.gz ||wget https://sourceware.org/systemtap/ftp/releases/systemtap-$(SYSTEMTAP_VERSION).tar.gz 
	tar -zxvf systemtap-$(SYSTEMTAP_VERSION).tar.gz
	cd systemtap-3.1 &&\
	./configure --prefix=$(SYSTEMTAP_PATH)  --disable-docs --disable-refdocs CFLAGS="-g -O2"  &&\
	make && make install
	sh -c 'echo PATH=$(SYSTEMTAP_PATH)/bin:$$PATH >> /etc/profile.d/devops.sh && source /etc/profile.d/devops.sh' &&\

flamegraph:
	test -d $(FLAMEGRAPH_PATH) || git clone https://github.com/brendangregg/FlameGraph $(FLAMEGRAPH_PATH)
	sh -c 'echo PATH=$(FLAMEGRAPH_PATH):$$PATH >> /etc/profile.d/devops.sh'

.ONESHELL:
openresty: prerequisites
	cd $(BUILD_PATH)
	echo downloading file openssl-$(OPENSSL_VERSION).tar.gz openssl-1.0.2h-sess_set_get_cb_yield.patch ...
	test -f openssl-$(OPENSSL_VERSION).tar.gz || wget https://www.openssl.org/source/openssl-$(OPENSSL_VERSION).tar.gz 
	test -f openssl-1.0.2h-sess_set_get_cb_yield.patch || wget https://raw.githubusercontent.com/openresty/openresty/master/patches/openssl-1.0.2h-sess_set_get_cb_yield.patch
	test -d openssl-$(OPENSSL_VERSION) && rm -fr openssl-$(OPENSSL_VERSION) 
	tar -zxvf  openssl-$(OPENSSL_VERSION).tar.gz || exit 1
	cd openssl-$(OPENSSL_VERSION)
	patch -p1 < ../openssl-1.0.2h-sess_set_get_cb_yield.patch
	cd $(BUILD_PATH)
	test -f pcre-$(PCRE_VERSION).tar.gz || wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$(PCRE_VERSION).tar.gz
	tar -xvf pcre-$(PCRE_VERSION).tar.gz
	cd $(BUILD_PATH)
	test -f 'openresty-$(OEPNRESTY_VERSION).tar.gz' || wget https://openresty.org/download/openresty-$(OEPNRESTY_VERSION).tar.gz
	test -d 'openresty-$(OEPNRESTY_VERSION)' || tar -zxvf openresty-$(OEPNRESTY_VERSION).tar.gz
	cd openresty-$(OEPNRESTY_VERSION) 
	./configure --prefix=$(OEPNRESTY_PATH) --with-pcre=$(BUILD_PATH)/pcre-$(PCRE_VERSION) --with-openssl=$(BUILD_PATH)/openssl-$(OPENSSL_VERSION) --with-debug --with-pcre-jit --with-ipv6 --with-http_gzip_static_module --with-http_stub_status_module  --with-http_ssl_module --with-http_realip_module
	make -j
	make install

#	sh -c 'echo PATH=$(OEPNRESTY_PATH)/bin:$$PATH >> /etc/profile.d/devops.sh && source /etc/profile.d/devops.sh'
#	echo "-------------------->"
#	cat /etc/profile.d/devops.sh
#	
# --with-http_ssl_module --with-http_realip_module --with-google_perftools_module --with-http_upstream_check_module --with-http_concat_module
.ONESHELL:
luarocks:
	cd $(BUILD_PATH)
	test -f luarocks-2.4.3.tar.gz || wget http://luarocks.github.io/luarocks/releases/luarocks-2.4.3.tar.gz
	tar -zxvf luarocks-2.4.3.tar.gz
	cd luarocks-2.4.3
	./configure  --lua-suffix=jit --with-lua-include=$(OEPNRESTY_PATH)/luajit/include/luajit-2.1
	make build
	make install
	luarocks install lua-resty-http
	
ONESHELL:
lor:
	cd $(BUILD_PATH)
	test -d lor || git clone https://github.com/sumory/lor.git
	cd lor && git pull && \
	sudo make install
orange: lor
	test -d $(ORANGE_PATH) || git clone  https://github.com/thisverygoodhhhh/orange.git $(ORANGE_PATH)
	cd $(ORANGE_PATH) && git checkout master

.ONESHELL:
php7: 
	cd $(BUILD_PATH)
	test -f php-$(PHP_VERSION).tar.gz || wget http://cn2.php.net/distributions/php-$(PHP_VERSION).tar.gz
	test -d  php-$(PHP_VERSION) || tar -zxvf php-$(PHP_VERSION).tar.gz
	test -d $(PHP_PATH) || (
		test -d $(BUILD_PATH)/openssl-$(OPENSSL_VERSION) || (cd $(BUILD_PATH)/openssl-$(OPENSSL_VERSION) && make && make install)
		cd $(BUILD_PATH)/php-$(PHP_VERSION) 
		./configure --prefix=$(PHP_PATH)/ --with-debug  --with-gd --enable-gd-native-ttf --with-zlib --with-mcrypt  --enable-shmop --enable-sockets --enable-wddx --enable-zip --enable-fpm --enable-mbstring --with-zlib-dir --with-bz2 --with-curl --enable-exif  --with-iconv=/usr/local/opt/libiconv/  --enable-xml --enable-inline-optimization --enable-bcmath  --with-openssl=$(BUILD_PATH)/openssl-$(OPENSSL_VERSION)/.openssl --enable-session --enable-fpm --enable-mbstring --enable-opcache  --with-pdo-mysql --enable-mysqlnd
		make
		make install 
		cp php.ini-production $(PHP_PATH)/lib/php.ini  
		cp $(PHP_PATH)/etc/php-fpm.conf.default $(PHP_PATH)/etc/php-fpm.conf 
		cp $(PHP_PATH)/etc/php-fpm.d/www.conf.default  $(PHP_PATH)/etc/php-fpm.d/www.conf 
		echo "zend_extension=opcache.so" >>  $(PHP_PATH)/lib/php.ini 
	)
		#sh -c 'echo PATH=$(PHP_PATH)/bin:$$PATH >> /etc/profile.d/devops.sh'
		#sh -c 'echo "export PATH=$(PHP_PATH)/sbin:$$PATH" >> /etc/profile.d/devops.sh'
		#echo "exce 'source /etc/profile.d/devops.sh' or reboot" 

.ONESHELL:
php7-ext-swoole:
	cd $(BUILD_PATH)
	test -f v$(PHP_SWOOLE_VERSION).tar.gz || wget https://github.com/swoole/swoole-src/archive/v$(PHP_SWOOLE_VERSION).tar.gz
	test -d swoole-src-$(PHP_SWOOLE_VERSION) || tar -zxvf v$(PHP_SWOOLE_VERSION).tar.gz
	cd swoole-src-$(PHP_SWOOLE_VERSION)/
	phpize
	./configure
	make
	make install
	sh -c 'echo "extension=swoole.so" >> $(PHP_PATH)/lib/php.ini'

	# php -m

# php7-clean:
	# cd $(BUILD_PATH)
	# rm -fr php-$(PHP_VERSION).tar.gz php-$(PHP_VERSION)

php7-ext-stomp: 
	test -f 'stomp-2.0.0.tgz'||wget https://pecl.php.net/get/stomp-2.0.0.tgz
	test -d 'stomp-2.0.0' || tar -zxvf stomp-2.0.0.tgz && \
	source ~/.bashrc && \
	cd stomp-2.0.0 && \
	phpize && ./configure && make && make install && \
	echo "extension=stomp.so" >> $(PHP_PATH)/lib/php.ini

php7-ext-redis: 
	test -f "redis.3.0.0.tar.gz" || wget https://github.com/phpredis/phpredis/archive/3.0.0.tar.gz  -O redis.3.0.0.tar.gz
	test -d "phpredis-3.0.0" || tar -zxvf  redis.3.0.0.tar.gz && \
	source ~/.bashrc && \
	cd phpredis-3.0.0 &&\
	phpize && ./configure && make && make install && \
	echo "extension=redis.so" >> $(PHP_PATH)/lib/php.ini

php7-ext-phalcon:
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

.ONESHELL:
php-amqp: librabbitmq
	mkdir -p $(BUILD_PATH)
	test -f amqp-$(PHP_AMQP_VERSION).tgz|| wget https://pecl.php.net/get/amqp-$(PHP_AMQP_VERSION).tgz
	test -d amqp-$(PHP_AMQP_VERSION) || tar -zxvf amqp-$(PHP_AMQP_VERSION).tgz
	cd amqp-$(PHP_AMQP_VERSION)
	phpize  
	./configure --with-amqp --with-librabbitmq-dir=/usr/local/
	make
	make install
	echo "extension=amqp.so"   >> $(PHP_PATH)/lib/php.ini
	make test

.ONESHELL:
librabbitmq:
	test -d $(BUILD_PATH)/rabbitmq-c || git clone https://github.com/alanxz/rabbitmq-c.git $(BUILD_PATH)/rabbitmq-c
	# (find / -name librabbitmq.so | grep -v 'rabbitmq-c' )||
	cd $(BUILD_PATH)/rabbitmq-c/
	git submodule init
	git submodule update
	((git branch|grep "* v0.8.0") || git checkout -b v0.8.0 v0.8.0 )
	autoreconf -i
	./configure
	mkdir -p build
	cd build
	cmake ..
	cmake --build .  --target install
	tt=`find / -name librabbitmq.so | grep -v 'rabbitmq-c'`
	tt1=$${tt:0:$${#tt}-15}
	echo "add '$$tt1' to  /etc/ld.so.conf.d/devpos.conf"
	echo $$tt1 >>  /etc/ld.so.conf.d/devpos.conf
	ldconfig

update-make:
	wget http://alpha.gnu.org/gnu/make/make-4.1.90.tar.gz
	tar -zxvf make-4.1.90.tar.gz
	cd make-4.1.90 && ./configure && make CFLAGS="-g -O2 -std=gnu99" && make install && make -v && which make

wrk:
	git clone https://github.com/wg/wrk.git
	cd wrk && \
	make && \
	cp wrk /bin
	wrk

# install-all: prerequisites openresty orange php7 php7-ext-stomp php7-ext-redis php7-ext-phalcon php-amqp php-composer


update-orange: orange
	cd $(ORANGE_PATH) && git checkout master && git pull origin master

update-lor: lor

bug-fedora:
	dnf upgrade perl-libs
