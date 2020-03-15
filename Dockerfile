ARG tag=latest
FROM debian:${tag}

MAINTAINER Francis Duffy
LABEL Description="Build zlib."

# Argument for number of cores to use while building
ARG num_cores

# Exclusions are performed by .dockerignore
COPY . /zlib

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -f -y build-essential dos2unix \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && cd /zlib \
  && find -regex ".*\.\(sh\|in\|ac\|am\)" -exec dos2unix {} ';' \
  && dos2unix configure \
  && ./configure \
  && make -j ${num_cores} \
  && make install \
  && cd / \
  && rm -rf zlib \
  && ldconfig

CMD bash
