#!/bin/bash

if [ ! -f /frist.marker ]; then
  if [ -z "$PENTAHO_PASSWORD" ]; then
    echo "Please set PENTAHO_PASSWORD"
    exit 1
  fi
  touch /frist.marker
fi

[[ -z "$PENTAHO_PASSWORD" ]] || echo "pentaho:$PENTAHO_PASSWORD" | chpasswd

/usr/sbin/sshd -D
