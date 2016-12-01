FROM ubuntu:14.04
MAINTAINER soul11201 "soul11201@gmail.com"
RUN apt-get update
RUN apt-get install -y php5-dev libpcre3-dev gcc make php5-mysql php5-fpm php5-cli
RUN apt-get install -y git 
RUN git clone git://github.com/phalcon/cphalcon.git  cphalcon && cd cphalcon/build && sudo ./install && cd .. && rm -rf cphalcon

RUN echo 'disable_functions = pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,'>>  /etc/php5/fpm/conf.d/diff-cli.ini

RUN echo 'memory_limit = 128M' >> /etc/php5/fpm/conf.d/diff-cli.ini

RUN mv /etc/php5/cli/php.ini /etc/php5/php.ini && mv /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.bak

RUN ln -s /etc/php5/php.ini /etc/php5/cli/php.ini && ln -s /etc/php5/php.ini /etc/php5/fpm/php.ini

RUN echo 'extension=phalcon.so' > /etc/php5/fpm/conf.d/30-phalcon.ini && echo 'extension=phalcon.so' > /etc/php5/cli/conf.d/30-phalcon.ini

RUN apt-get install -y php5-redis

RUN apt-get install -y re2c 
RUN apt-get install -y php5-json 
RUN apt-get install -y php5-gd
RUN apt-get install -y php5-curl

EXPOSE 80

ENTRYPOINT ["/usr/bin/php","-S","0.0.0.0:80","-t", "/app/public","/app/.htrouter.php"]