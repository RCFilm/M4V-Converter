FROM linuxserver/sabnzbd:latest AS base
MAINTAINER sparklyballs

RUN \
    apt-get -yqq update && \
    apt-get install -yq --no-install-recommends ca-certificates expat libgomp1 && \
    apt-get autoremove -y && \
    apt-get clean -y

FROM jrottenberg/ffmpeg:snapshot-ubuntu AS build
MAINTAINER Julien Rottenberg <julien@rottenberg.info>

FROM base AS release
MAINTAINER xzKinGzxBuRnzx

ENV     LD_LIBRARY_PATH=/usr/local/lib

RUN \
    mkdir -p /app/M4V-Converter && \
    cd /tmp && \
    curl -s -o M4V-Converter.tar.gz -L https://github.com/Digiex/M4V-Converter/archive/master.tar.gz && \
    tar xzvf M4V-Converter.tar.gz && \
    cp \
        M4V-Converter-master/M4V-Converter.sh \
        M4V-Converter-master/default.conf \
        M4V-Converter-master/LICENSE \
        /app/M4V-Converter/ && \
    rm -rf M4V-Converter*

COPY sabnzbd.sh /app/M4V-Converter/
COPY root /
COPY sabnzbd.ini /defaults/
COPY --from=build /usr/local /usr/local
