#
# Docker Image
#
FROM ubuntu:14.04
MAINTAINER Nicolas DIERICK <nicolas.dierick@picomto.com>

ENV DEBIAN_FRONTEND noninteractive

#Install default tools
RUN apt-get -qq update && \
    apt-get install -qqy \
        software-properties-common \
        curl \
        ssh \
        net-tools \
        openssh-server \
        apache2 \
        memcached \
        php5 \
        php5-mysql \
        php5-curl \
        php5-memcache \
        imagemagick \
        pngcrush \
        texlive-* \
        libjpeg-progs \
        mysql-client \
        inkscape && \
    rm -rf /var/lib/apt/lists/*

#Install ffmpeg
RUN add-apt-repository -y ppa:mc3man/trusty-media && \
    apt-get update && \
    apt-get install -qqy ffmpeg \
        libav-tools

#Install Java
RUN add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -qqy oracle-java8-installer

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80
CMD ["/usr/sbin/apache2", "-D",  "FOREGROUND"]