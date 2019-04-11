FROM openjdk:8-jdk as run

MAINTAINER Dremio-modified

LABEL org.label-schema.name='dremio/dremio-oss'
LABEL org.label-schema.description='Dremio OSS.'

ARG DOWNLOAD_URL=https://download.dremio.com/community-server/3.0.1-201811132128360291-804fe82/dremio-community-3.0.1-201811132128360291-804fe82.tar.gz
RUN \
  mkdir -p /opt/dremio \
  && mkdir -p /var/lib/dremio \
  && mkdir -p /var/run/dremio \
  && mkdir -p /var/log/dremio \
  && mkdir -p /opt/dremio/data \
  \
  && groupadd --system dremio \
  && useradd --base-dir /var/lib/dremio --system --gid dremio hdfs \
  && chown -R hdfs:dremio /opt/dremio/data \
  && chown -R hdfs:dremio /var/run/dremio \
  && chown -R hdfs:dremio /var/log/dremio \
  && chown -R hdfs:dremio /var/lib/dremio \
  && wget -q "${DOWNLOAD_URL}" -O dremio.tar.gz \
  && tar vxfz dremio.tar.gz -C /opt/dremio --strip-components=1 \
  && rm -rf dremio.tar.gz

EXPOSE 9047/tcp
EXPOSE 31010/tcp
EXPOSE 45678/tcp

USER hdfs
WORKDIR /opt/dremio
ENV DREMIO_HOME /opt/dremio
ENV DREMIO_PID_DIR /var/run/dremio
ENV DREMIO_GC_LOGS_ENABLED="no"
ENV DREMIO_LOG_DIR="/var/log/dremio"
ENV SERVER_GC_OPTS="-XX:+PrintGCDetails -XX:+PrintGCDateStamps"
ENTRYPOINT ["bin/dremio", "start-fg"]

