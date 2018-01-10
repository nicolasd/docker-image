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
        phpmyadmin \
        pngcrush \
        texlive-* \
        libjpeg-progs \
        mysql-client \
        inkscape \
#        build-essential \
#        checkinstall \
#        autoconf \
#        automake \
#        build-essential \
#        cmake \
#        git \
#        libass-dev \
#        libfreetype6-dev \
#        libsdl2-dev \
#        libtheora-dev \
#        libtool \
#        libva-dev \
#        libvdpau-dev \
#        libvorbis-dev \
#        libxcb1-dev \
#        libxcb-shm0-dev \
#        libxcb-xfixes0-dev \
#        mercurial \
#        pkg-config \
#        texinfo \
        zlib1g-dev

#Install Java
RUN add-apt-repository -y ppa:webupd8team/java \
    && apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
RUN apt-get install -qqy oracle-java8-installer

#Install last Image Magick
RUN apt-get build-dep imagemagick -y
RUN wget "http://www.imagemagick.org/download/ImageMagick.tar.gz" \
    && tar -xvzf ImageMagick.tar.gz \
    && cd `ls -d */ -1 | head -n 1` \
    && ./configure --prefix=/opt/imagemagick-picomto \
    && sudo make \
    && checkinstall -D --install=yes -y

#Install Latex dependencies
RUN wget http://mirrors.ctan.org/macros/latex/contrib/anyfontsize.zip \
    && unzip anyfontsize.zip \
    && cd anyfontsize \
    && mkdir /usr/share/texlive/texmf/tex/plain/anyfontsize/ -p \
    && cp anyfontsize.sty /usr/share/texlive/texmf/tex/plain/anyfontsize/ \
    && mkdir /var/lib/texmf/plain/anyfontsize/ -p \
    && cp anyfontsize.tex /var/lib/texmf/plain/anyfontsize/anyfontsize.tex \
    && wget http://mirrors.ctan.org/macros/latex/contrib/seqsplit.zip \
    && cd seqsplit \
    && make \
    && mkdir /usr/share/texlive/texmf/tex/plain/seqsplit/ -p \
    && cp *.sty /usr/share/texlive/texmf/tex/plain/seqsplit/ \
    && wget http://mirrors.ctan.org/macros/latex/contrib/xwatermark.zip \
    && unzip xwatermark.zip \
    && cd xwatermark/tex \
    && mkdir /usr/share/texlive/texmf/tex/plain/xwatermark/ -p \
    && cp xwatermark.sty /usr/share/texlive/texmf/tex/plain/xwatermark/ \
    && wget http://mirrors.ctan.org/macros/latex/contrib/catoptions.zip \
    && unzip catoptions.zip \
    && cd catoptions/tex \
    && mkdir /usr/share/texlive/texmf/tex/plain/catoptions/ -p \
    && cp catoptions.sty /usr/share/texlive/texmf/tex/plain/catoptions/ \
    && wget http://mirrors.ctan.org/macros/latex/contrib/ltxkeys.zip \
    && unzip ltxkeys.zip \
    && cd ltxkeys \
    && mkdir /usr/share/texlive/texmf/tex/plain/ltxkeys/ -p \
    && cp ltxkeys.sty /usr/share/texlive/texmf/tex/plain/ltxkeys/ \
    && texhash

#Install FFMPEG dependencies
RUN mkdir -p ~/ffmpeg_sources ~/bin \
    && cd ~/ffmpeg_sources \
    && wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.02/nasm-2.13.02.tar.bz2 \
    && tar xjvf nasm-2.13.02.tar.bz2 \
    && cd nasm-2.13.02 \
    && ./autogen.sh \
    && PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" \
    && make \
    && make install \
    && cd ~/ffmpeg_sources \
    && wget -O yasm-1.3.0.tar.gz http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz \
    && tar xzvf yasm-1.3.0.tar.gz \
    && cd yasm-1.3.0 \
    && ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" \
    && make \
    && make install \
    && cd ~/ffmpeg_sources \
    && git -C x264 pull 2> /dev/null || git clone --depth 1 http://git.videolan.org/git/x264 \
    && cd x264 \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static \
    && PATH="$HOME/bin:$PATH" make \
    && make install \
    && cd ~/ffmpeg_sources \
    && if cd x265 2> /dev/null; then hg pull \
    && hg update; else hg clone https://bitbucket.org/multicoreware/x265; fi \
    && cd x265/build/linux \
    && PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source \
    && PATH="$HOME/bin:$PATH" make \
    && make install \
    && cd ~/ffmpeg_sources \
    && git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git \
    && cd libvpx \
    && PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm \
    && PATH="$HOME/bin:$PATH" make \
    && make install \
    && cd ~/ffmpeg_sources \
    && git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac \
    && cd fdk-aac \
    && autoreconf -fiv \
    && ./configure --prefix="$HOME/ffmpeg_build" --disable-shared \
    && make \
    && make install \
    && cd ~/ffmpeg_sources \
    && wget -O lame-3.100.tar.gz http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz \
    && tar xzvf lame-3.100.tar.gz \
    && cd lame-3.100 \
    && PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm \
    && PATH="$HOME/bin:$PATH" make \
    && make install \
    && cd ~/ffmpeg_sources \
    && git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git \
    && cd opus \
    && ./autogen.sh \
    && ./configure --prefix="$HOME/ffmpeg_build" --disable-shared \
    && make \
    && make install

#Install FFMPEG
RUN cd ~/ffmpeg_sources \
    && wget -O ffmpeg-snapshot.tar.bz2 http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 \
    && tar xjvf ffmpeg-snapshot.tar.bz2 \
    && cd ffmpeg \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
      --prefix="$HOME/ffmpeg_build" \
      --pkg-config-flags="--static" \
      --extra-cflags="-I$HOME/ffmpeg_build/include" \
      --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
      --extra-libs="-lpthread -lm" \
      --bindir="$HOME/bin" \
      --enable-gpl \
      --enable-libass \
      --enable-libfdk-aac \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libtheora \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-nonfree \
    && PATH="$HOME/bin:$PATH" make \
    && make install \
    && hash -r \
    && cd ~/bin \
    && cp * /usr/bin/

#Install QTFaststart
RUN cd ~/ffmpeg_sources/ffmpeg/tools \
    && gcc qt-faststart.c -o qt-faststart \
    && cp qt-faststart /usr/bin/

#Configure Apache
RUN a2enmod headers \
    && a2enmod rewrite

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod u+rwx /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 443 80 22


#TODO MYSQL SERVER