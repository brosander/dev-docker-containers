#!/bin/bash

if [ "$(ls -A /data-integration-server)" ]; then
  echo "/data-integration-server folder not empty, using existing"
elif [ ! -z "$DISERVER_URL" ]; then
  wget -nv -O /diserver.zip "$DISERVER_URL" && unzip -d / /diserver.zip && rm /diserver.zip
else
  echo 'Must specify $DISERVER_URL if /data-integration-server folder not mounted'
  exit 1
fi

chown -R pentaho:pentaho /data-integration-server
rm -r /data-integration-server/pentaho-solutions/system/karaf/data*

/root/postgres-start.sh
/root/install_licenses.sh

if [ ! -f /frist.diserver.marker ]; then
  touch /frist.diserver.marker

  echo 'Loading pentaho data'
  cd /data-integration-server/data/postgresql/
  export PGPASSWORD="$POSTGRES_PASSWORD" && for i in `ls *.sql | grep create`; do psql -U postgres -f $i; done; psql -U postgres -d di_hibernate -f pentaho_mart_drop_postgresql.sql; psql -U postgres -d di_hibernate -f pentaho_mart_postgresql.sql
  echo 'Data load complete; ready for start up.'
else
  echo 'Skipping diserver dataload as it has already occured once'
fi

gosu pentaho /data-integration-server/start-pentaho-debug.sh
tail -f /data-integration-server/tomcat/logs/catalina.out &
/root/startSshServer.sh
