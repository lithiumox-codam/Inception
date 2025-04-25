#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
DATADIR="/var/lib/mysql"
INIT_MARKER_FILE="${DATADIR}/.db_initialized"

# --- Helper Functions ---
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] - $1"
}

# --- Check Required Environment Variables ---
for var in DB_ROOT_PASSWORD DB_NAME DB_USER DB_PASSWORD; do
  if [ -z "${!var}" ]; then
    log "ERROR: Missing required environment variable: $var"
    exit 1
  fi
done

# --- Database Initialization (only if directory is empty/uninitialized) ---
if [ ! -f "${INIT_MARKER_FILE}" ]; then
  log "Database directory appears uninitialized. Running initial setup..."

  # Initialize the MariaDB data directory
  mariadb-install-db --user=mysql --datadir=${DATADIR}
  
  # Start MariaDB temporarily - limiting to localhost for security
  mysqld --user=mysql --datadir=${DATADIR} --bind-address=127.0.0.1 &
  pid="$!"
  
  # Wait for the server to start
  for i in {1..30}; do
    if mysqladmin ping --silent; then
      break
    fi
    log "Waiting for temporary server... ($i/30)"
    sleep 1
  done
  
  # Configure the database
  mysql --user=root <<-EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE IF EXISTS test;
    CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
    CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL
  
  # Stop the temporary server
  mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown || kill "$pid"
  wait "$pid"
  
  # Create the marker file
  touch "${INIT_MARKER_FILE}"
  chown mysql:mysql "${INIT_MARKER_FILE}"
  log "Initialization complete."
else
  log "Database directory already initialized."
fi

# Just execute the CMD as-is
log "Starting MariaDB server..."
exec "$@"