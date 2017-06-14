#
# Docker Image
#
FROM ubuntu:14.04
MAINTAINER Nicolas DIERICK <nicolas.dierick@picomto.com>

ENV DEBIAN_FRONTEND noninteractive

#Install default tools
RUN apt-get -qq update && \
    apt-get install -qqy \
      curl \
      openjdk-8-jdk \
      ssh \
      net-tools \
      openssh-server \
      apache2 \
      memcached \
      php5 \
      php5-mysql \
      php5-curl \
      imagemagick \
      pngcrush \
      texlive-* \
      libjpeg-progs \
      inkscape

#Install ffmpeg
RUN add-apt-repository ppa:mc3man/trusty-media && \
        apt-get update && \
        apt-get install -qqy ffmpeg \
            libav-tools \

