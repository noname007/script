FROM ubuntu:14.04
MAINTAINER soul11201 "soul11201@gmail.com"
RUN apt-get update
RUN apt-get install -y nginx
RUN echo 'Hi, I am in your container'  > /usr/share/nginx/html/index.html
EXPOSE 80