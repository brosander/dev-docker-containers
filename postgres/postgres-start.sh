#!/bin/bash

if [ -z "$POSTGRES_PASSWORD" ]; then
  echo "Warning, postgres password not set, using default"
  export POSTGRES_PASSWORD=password
fi

if [ ! -f /frist.marker ]; then
  touch /frist.marker
  echo "Performing first time postgres setup"
  sed -ri "s/^#?(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA/postgresql.conf"

  mkdir -p "$PGDATA"
  chown -R postgres "$PGDATA"

  chmod g+s /run/postgresql
  chown -R postgres /run/postgresql

  gosu postgres initdb
  pass="PASSWORD '$POSTGRES_PASSWORD'"
  authMethod=md5

  { echo; echo "host all all 0.0.0.0/0 $authMethod"; } >> "$PGDATA/pg_hba.conf"
  gosu postgres pg_ctl -D "$PGDATA" -o "-c listen_addresses=''" -w start

  export POSTGRES_USER=postgres
  export POSTGRES_DB=postgres

  psql --username postgres <<-EOSQL
      ALTER USER "$POSTGRES_USER" WITH SUPERUSER $pass ;
EOSQL

  echo 'PostgreSQL init process complete'
  gosu postgres pg_ctl -D "$PGDATA" -m fast -w stop
else
  echo 'Skipping first time setup as it has already occured once'
fi

gosu postgres postgres &
