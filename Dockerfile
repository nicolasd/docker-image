#
# Docker Image
#
FROM ubuntu:14.04
MAINTAINER Nicolas DIERICK <nicolas.dierick@picomto.com>

ENV DEBIAN_FRONTEND noninteractive

#Install default tools
RUN apt-get -qq update \
    && apt-get install -qqy \
        software-properties-common \
        ca-certificates \
        wget \
        vim \
        nano \
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
        pngcrush \
        texlive-* \
        libjpeg-progs \
        mysql-client \
        inkscape \
        git \
        cmake \
        checkinstall \
        mercurial \
        autoconf \
        automake \
        build-essential \
        libass-dev \
        libfreetype6-dev \
#        libsdl2-dev \
        libtheora-dev \
        libtool \
        libva-dev \
        libvdpau-dev \
        libvorbis-dev \
        libxcb1-dev \
        libxcb-shm0-dev \
        libxcb-xfixes0-dev \
        librsvg2 \
        librsvg2-devel \
        libxml2-devel \
        pkg-config \
        texinfo \
        zlib1g-dev > /tmp/aptlog

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod u+rwx /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK CMD /healthcheck.sh

EXPOSE 443 80 22
