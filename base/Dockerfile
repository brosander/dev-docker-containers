from cogniteev/oracle-java:java7

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
  ENV LANG en_US.utf8

RUN apt-get update
RUN apt-get install -y wget unzip openssh-server

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4

RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)"
RUN wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc"
RUN gpg --verify /usr/local/bin/gosu.asc
RUN rm /usr/local/bin/gosu.asc
RUN chmod +x /usr/local/bin/gosu

RUN groupadd -r pentaho --gid=1024 && useradd -m -g pentaho --uid=1024 pentaho
RUN adduser pentaho sudo

run mkdir /var/run/sshd
run chmod 0755 /var/run/sshd

COPY startSshServer.sh /root/startSshServer.sh
COPY install_licenses.sh /root/install_licenses.sh

VOLUME /license-installer
VOLUME /pentaho-licenses

ENTRYPOINT ["/root/startSshServer.sh"]
