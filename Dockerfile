FROM ubuntu:jammy

# Build ImageMagick v7
# not available in debian yet?
# Borrowed from: https://github.com/dooman87/imagemagick-docker

ARG IM_VERSION=7.1.0-48
ARG LIB_HEIF_VERSION=1.13.0
ARG LIB_AOM_VERSION=3.4.0
ARG LIB_WEBP_VERSION=1.2.4
ARG LIBJXL_VERSION=0.6.1

# TODO:
# - How about more static linking?
# - cleaning up in the image is probably not needed any more, we will use this image only in multistage builds.

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y git make gcc pkg-config autoconf curl g++ \
    # libaom
    yasm cmake \
    # libheif
    libde265-0 libde265-dev libjpeg-turbo8 libjpeg-turbo8-dev x265 libx265-dev libtool \
    # IM
    libpng16-16 libpng-dev libjpeg-turbo8 libjpeg-turbo8-dev libwebp7 libwebp-dev libgomp1 libwebpmux3 libwebpdemux2 ghostscript libxml2-dev libxml2-utils && \
    # Building libaom
    git clone https://aomedia.googlesource.com/aom && \
    cd aom && git checkout v${LIB_AOM_VERSION} && cd .. && \
    mkdir build_aom && \
    cd build_aom && \
    cmake ../aom/ -DENABLE_TESTS=0 -DBUILD_SHARED_LIBS=1 && make && make install && \
    ldconfig /usr/local/lib && \
    cd .. && \
    rm -rf aom && \
    rm -rf build_aom && \
    # Building libheif
    curl -L https://github.com/strukturag/libheif/releases/download/v${LIB_HEIF_VERSION}/libheif-${LIB_HEIF_VERSION}.tar.gz -o libheif.tar.gz && \
    tar -xzvf libheif.tar.gz && cd libheif-${LIB_HEIF_VERSION}/ && ./autogen.sh && ./configure && make && make install && cd .. && \
    ldconfig /usr/local/lib && \
    rm -rf libheif-${LIB_HEIF_VERSION} && rm libheif.tar.gz && \
    # Building ImageMagick
    git clone https://github.com/ImageMagick/ImageMagick.git && \
    cd ImageMagick && git checkout ${IM_VERSION} && \
    ./configure --without-magick-plus-plus --disable-docs --disable-static && \
    make && make install && \
    ldconfig /usr/local/lib && \
    apt-get remove --autoremove --purge -y gcc make cmake curl g++ yasm git autoconf pkg-config libpng-dev libjpeg-turbo8-dev  libwebp-dev libde265-dev libx265-dev libxml2-dev && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /ImageMagick


