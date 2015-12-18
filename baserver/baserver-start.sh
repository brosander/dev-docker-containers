#!/bin/bash

if [ "$(ls -A /biserver-ee)" ]; then
  echo "/biserver-ee folder not empty, using existing"
elif [ ! -z "$BASERVER_URL" ]; then
  wget -nv -O /baserver.zip "$BASERVER_URL" && unzip -d / /baserver.zip && rm /baserver.zip
else
  echo 'Must specify $BASERVER_URL if /biserver-ee folder not mounted'
  exit 1
fi

chown -R pentaho:pentaho /biserver-ee
rm -r /biserver-ee/pentaho-solutions/system/karaf/data*

/root/postgres-start.sh
/root/install_licenses.sh

if [ ! -f /frist.baserver.marker ]; then
  touch /frist.baserver.marker

  echo 'Loading pentaho data'
  cd /biserver-ee/data/postgresql/
  export PGPASSWORD="$POSTGRES_PASSWORD" && for i in `ls *.sql | grep create`; do psql -U postgres -f $i; done; psql -U postgres -d hibernate -f pentaho_mart_drop_postgresql.sql; psql -U postgres -d hibernate -f pentaho_mart_postgresql.sql
  echo 'Data load complete; ready for start up.'
else
  echo 'Skipping diserver dataload as it has already occured once'
fi

gosu pentaho /biserver-ee/start-pentaho-debug.sh
tail -f /biserver-ee/tomcat/logs/catalina.out &
/root/startSshServer.sh
