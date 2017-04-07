## 简介

使用此脚本可以构建基于openresty的生态系统以及php7及其扩展的的编译安装。


### 现在集成进来的包括：

__openresty相关__
- openresty
- orange
- lor


__php相关__

php 扩展
- phalcon
- amqp
- stomp
- phpredis
- composer

__其他：__
- wrk
- make
- systemtap (下面是已经测试过的系统)
    + ubunutu 16.04
    + fedora 25


### makefile 概要

- `update-*`  目标。用于升级一些软件，包括make,lor,orange,hosts翻墙等。
- `deb-*` `yum-*` 目标。用于升级一些包软件，包括shell。
- `check-*`目标。 用于检查安装后的软件是否能正常运行。
- `fedora-*` 目标，针对fedora系统的一些操作。
- `bugs-*` 碰到的一些bug，解决方法。
- 一些PATH 环境变量会被添加到 /etc/profile.d/devops.sh



### 用法：

    make echo  输出所有的默认的 安装路径，版本

    make echo SOFTWARE_PATH=/usr/local BUILD_PATH=$HOME

- SOFTWARE_PATH 指定软件的安装目录，makefile又中加了一个后缀。 执行此条，所有的软件会被安装到/usr/local/software 中。
- BUILD_PATH 构建过程中一下，用于指定下载的软件包目录。
其他的
- `_VERSION` 后缀的，用于指定软件的版本号







