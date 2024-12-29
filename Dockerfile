FROM docker.io/library/ubuntu:24.04 AS build

ARG BRUTEFORCE_WALLET_VERSION

# SHELL [ "/bin/bash" ]

# RUN apk add autoconf bash curl db git openssl
RUN apt update && \
    apt upgrade --yes && \
    apt install --yes autoconf build-essential git libdb-dev libssl-dev make openssl

RUN if [ -z "${BRUTEFORCE_WALLET_VERSION+x}" ]; then git clone https://github.com/glv2/bruteforce-wallet.git /src; fi
RUN if [ -n "${BRUTEFORCE_WALLET_VERSION+x}" ]; then git clone --branch ${BRUTEFORCE_WALLET_VERSION} https://github.com/glv2/bruteforce-wallet.git /src; fi

# compile
RUN cd /src && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make && \
    make install DESTDIR=/cache && \
    rm -rf /src

FROM docker.io/library/ubuntu:24.04

COPY --from=build /cache /

ENTRYPOINT [ "/usr/bin/bruteforce-wallet" ]
