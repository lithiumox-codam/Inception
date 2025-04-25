#!/bin/bash

set -e

DATADIR="/var/lib/mysql"
INIT_MARKER_FILE="${DATADIR}/.db_initialized"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] - $1"
}

for var in DB_ROOT_PASSWORD DB_NAME DB_USER DB_PASSWORD; do
  if [ -z "${!var}" ]; then
    log "ERROR: Missing required environment variable: $var"
    exit 1
  fi
done

if [ ! -f "${INIT_MARKER_FILE}" ]; then
  log "Database directory appears uninitialized. Running initial setup..."

  mariadb-install-db --user=mysql --datadir=${DATADIR}
  
  mysqld --user=mysql --datadir=${DATADIR} --bind-address=127.0.0.1 &
  pid="$!"
  
  for i in {1..30}; do
    if mysqladmin ping --silent; then
      break
    fi
    log "Waiting for temporary server... ($i/30)"
    sleep 1
  done
  
  mysql --user=root <<-EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE IF EXISTS test;
    CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
    CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL
  
  mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown || kill "$pid"
  wait "$pid"
  
  touch "${INIT_MARKER_FILE}"
  chown mysql:mysql "${INIT_MARKER_FILE}"
  log "Initialization complete."
else
  log "Database directory already initialized."
fi

log "Starting MariaDB server..."
exec "$@"