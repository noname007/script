FROM centos:7
MAINTAINER soul11201 "soul11201@gmail.com"

RUN yum install -y epel-release

RUN yum -y install initscripts && yum clean all

RUN yum install -y cobbler
