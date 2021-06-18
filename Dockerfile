FROM golang:latest

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

RUN apt-get update && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
    cmake liblzo2-dev && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/storages
WORKDIR /app/wal-g

COPY . .

RUN cd submodules/brotli && ls -al && \
    mkdir out && cd out && \
    ../configure-cmake --disable-debug && \
    make && make install

RUN make install 
RUN make deps
RUN make pg_build
RUN make pg_install GOBIN=/usr/local/bin

RUN /usr/local/bin/wal-g --help