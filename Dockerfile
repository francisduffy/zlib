ARG tag=latest
FROM debian:${tag}

MAINTAINER Francis Duffy
LABEL Description="Build zlib."

# Argument for number of cores to use while building
ARG num_cores

# Allow to switch to a debug build.
ARG build_type

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
  && if [ -z "${build_type}" ] ; then \
       ./configure; \
     elif [ "${build_type}" = "debug" ] ; then \
       CFLAGS="-O0 -g" ./configure --debug; \
     else \
       ./configure; \
     fi \
  && make -j ${num_cores} \
  && make install \
  && cd / \
  && rm -rf zlib \
  && ldconfig

CMD bash
