# Base image from SwiftDocker
# https://hub.docker.com/r/swiftdocker/swift/
FROM openjdk:10-jdk-slim-sid

RUN apt-get update && \
    apt-get install -y \
        git cmake ninja-build clang python uuid-dev libicu-dev icu-devtools \
        libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev \
        libncurses5-dev pkg-config libblocksruntime-dev libcurl4-openssl-dev \
        systemtap-sdt-dev tzdata rsync swig curl

RUN mkdir -p /opt

RUN cd /opt && \
    git clone https://github.com/apple/swift.git

WORKDIR /opt/swift
RUN git checkout swift-4.2-branch

RUN /opt/swift/utils/update-checkout --clone
RUN /opt/swift/utils/build-toolchain org.swift


RUN find . \
    -maxdepth 1 \
    -type f \
    -name 'swift-LOCAL*-a-osx.tar.gz' \
    -exec cat {} \; | \
    tar xvz -C /

WORKDIR /opt
RUN curl https://download-cf.jetbrains.com/cpp/CLion-2018.2.6.tar.gz | tar xz 

RUN echo 'export PATH="$PATH:$HOME/bin"' >> ~/.bashrc
