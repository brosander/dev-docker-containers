from bryanrosander/pentaho-base

# Postgres (courtesy of https://github.com/docker-library/postgres/blob/ed23320582f4ec5b0e5e35c99d98966dacbc6ed8/9.3/Dockerfile) + Diserver

RUN apt-get update
RUN apt-get install -y ca-certificates

# Install postgres

RUN groupadd -r postgres --gid=999 && useradd -r -g postgres --uid=999 postgres
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

ENV PG_MAJOR 9.3
ENV PG_VERSION 9.3.10-1.pgdg14.04+1

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update
RUN apt-get install -y postgresql-common
RUN sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf
RUN apt-get install -y postgresql-$PG_MAJOR=$PG_VERSION postgresql-contrib-$PG_MAJOR=$PG_VERSION

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
ENV PGDATA /var/lib/postgresql/data

VOLUME /var/lib/postgresql/data

COPY postgres-start.sh /root/postgres-start.sh
