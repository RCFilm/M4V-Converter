FROM linuxserver/nzbget:latest AS base
MAINTAINER sparklyballs

RUN apk add --no-cache --update libgcc libstdc++ ca-certificates libcrypto1.0 libssl1.0 libgomp expat

FROM jrottenberg/ffmpeg:snapshot-alpine AS build
MAINTAINER Julien Rottenberg <julien@rottenberg.info>

FROM base AS release
MAINTAINER xzKinGzxBuRnzx

ENV LD_LIBRARY_PATH=/usr/local/lib

RUN \
    mkdir -p /app/M4V-Converter && \
    cd /tmp && \
    wget -q -O M4V-Converter.tar.gz https://github.com/Digiex/M4V-Converter/archive/master.tar.gz && \
    tar xzvf M4V-Converter.tar.gz && \
    cp \
        M4V-Converter-master/M4V-Converter.sh \
        M4V-Converter-master/default.conf \
        M4V-Converter-master/LICENSE \
        M4V-Converter-master/README.md \
        /app/M4V-Converter/ && \
    ln -s /app/M4V-Converter /app/nzbget/scripts/M4V-Converter && \
    rm -rf M4V-Converter* && \
    sed -i -e "s#\(ScriptDir=\).*#\1$\{AppDir\}/scripts#g" /defaults/nzbget.conf

COPY root /
COPY --from=build /usr/local /usr/local