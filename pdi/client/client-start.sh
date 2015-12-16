#!/bin/bash

if [ "$(ls -A /data-integration)" ]; then
  echo "/data-integration folder not empty, using existing"
elif [ ! -z "$PDI_CLIENT_URL" ]; then
  wget -nv -O /pdi-client.zip "$PDI_CLIENT_URL" && unzip -d / /pdi-client.zip && rm /pdi-client.zip
else
  echo 'Must specify $PDI_CLIENT_URL if data-integration folder not mounted'
  exit 1
fi

chown -R pentaho:pentaho /data-integration
rm -r /data-integration/system/karaf/data

/root/install_licenses.sh
/root/startSshServer.sh
