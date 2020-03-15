ARG boost_version=latest
FROM build_env_boost:${boost_version}

MAINTAINER Francis Duffy
LABEL Description="Build zlib."

# Argument for number of cores to use while building
ARG num_cores

# Exclusions are performed by .dockerignore
COPY . /zlib

RUN cd /zlib \
  && find -regex ".*\.\(sh\|in\|ac\|am\)" -exec dos2unix {} ';' \
  && dos2unix configure \
  && ./configure \
  && make -j ${num_cores} \
  && make install \
  && cd / \
  && rm -rf zlib \
  && ldconfig

CMD bash
