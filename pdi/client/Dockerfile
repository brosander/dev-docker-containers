from bryanrosander/pentaho-base

RUN apt-get update
RUN apt-get install -y firefox libxtst6 libwebkitgtk-1.0-0

VOLUME /data-integration
VOLUME /pentaho-licenses

COPY client-start.sh /root/client-start.sh

ENTRYPOINT ["/root/client-start.sh"]
