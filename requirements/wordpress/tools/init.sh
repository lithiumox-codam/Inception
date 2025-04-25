#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
WP_PATH="/var/www/html"
WP_SOURCE_DIR="/usr/src/wordpress" # Must match ENV in Dockerfile
WP_CONFIG_FILE="${WP_PATH}/wp-config.php"
MAX_DB_WAIT=30 # Maximum seconds to wait for the database

# --- Helper Functions ---
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WP Entrypoint] - $1"
}

# --- Check Required Environment Variables ---
required_vars=(
  DB_HOST DB_USER DB_PASSWORD DB_NAME
  DOMAIN_NAME WP_ADMIN_USER WP_ADMIN_PASSWORD WP_ADMIN_EMAIL
  WP_USER_NAME WP_USER_PASSWORD WP_USER_EMAIL WP_USER_ROLE
)
missing_vars=()
for var in "${required_vars[@]}"; do
  # Use parameter expansion with :? to exit if var is unset or null
  : "${!var:?ERROR: Missing required environment variable: $var}"
done

# --- Populate Volume ---
# Check if the target directory (volume mount) is empty by looking for a core file.
if [ ! -f "${WP_PATH}/wp-includes/version.php" ]; then
  log "WordPress directory (${WP_PATH}) appears empty."
  log "Copying files from image source ${WP_SOURCE_DIR}..."
  # Use cp -a to preserve ownership/permissions if possible, '.' copies hidden files.
  # Using cp -rp as a robust alternative.
  cp -rp "${WP_SOURCE_DIR}/." "${WP_PATH}/"
  log "Files copied."
  # Ensure ownership is correct *after* copying into the volume
  log "Setting ownership for ${WP_PATH}..."
  # Use 'nobody' user/group as defined in Dockerfile and www.conf
  chown -R nobody:nobody "${WP_PATH}"
  log "Ownership set for volume contents."
else
    log "WordPress directory (${WP_PATH}) already contains files. Skipping copy."
    # Optional: Ensure permissions are still correct on existing volume
    # log "Verifying ownership for existing ${WP_PATH}..."
    # chown -R nobody:nobody "${WP_PATH}"
    # log "Ownership verified."
fi

# --- Wait for Database ---
log "Waiting for database host ${DB_HOST}..."
counter=0
# Use mariadb-admin which is installed by mysql-client package
while ! mariadb-admin ping -h"${DB_HOST}" -u"${DB_USER}" -p"${DB_PASSWORD}" --silent --connect-timeout=1; do
  counter=$((counter + 1))
  if [ $counter -ge $MAX_DB_WAIT ]; then
    log "ERROR: Database connection timed out after ${MAX_DB_WAIT} seconds."
    exit 1
  fi
  log "Database unavailable, waiting 1 second... (${counter}/${MAX_DB_WAIT})"
  sleep 1
done
log "Database connection successful!"

# --- WordPress Setup ---
# Change directory *after* potentially copying files and waiting for DB
cd ${WP_PATH}

# Create wp-config.php if it doesn't exist
if [ ! -f "${WP_CONFIG_FILE}" ]; then
  log "Creating wp-config.php..."
  # Generate salts using WP-CLI if possible, otherwise use placeholder
  # (Requires internet access from container during build/runtime)
  # wp config set --allow-root --type=constant WP_DEBUG false --raw
  # wp config shuffle-salts --allow-root

  # Use wp-cli to generate wp-config.php
  # --allow-root is needed because this script runs as root initially
  wp config create --allow-root \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASSWORD}" \
    --dbhost="${DB_HOST}" \
    --skip-check \
    --extra-php <<PHP
define('FS_METHOD', 'direct'); // Often needed for plugin/theme installs in Docker
// Add any other custom defines here if needed
// define( 'WP_DEBUG', false );
PHP
  log "wp-config.php created."
  # Set permissions for wp-config.php specifically
  chown nobody:nobody "${WP_CONFIG_FILE}"
  chmod 640 "${WP_CONFIG_FILE}" # More secure permissions
else
  log "wp-config.php already exists."
fi

# Install WordPress core if not already installed
# Use --path to be explicit, though WORKDIR should handle it
if ! wp core is-installed --allow-root --path="${WP_PATH}"; then
  log "Installing WordPress core..."
  # Run core install as the 'nobody' user to avoid permission issues later
  # Requires sudo package to be installed in Dockerfile
  sudo -u nobody -E wp core install --path="${WP_PATH}" \
    --url="https://${DOMAIN_NAME}" \
    --title="Inception - ${DOMAIN_NAME}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email
  log "WordPress core installed."

  # Create the second user (only after core install)
  log "Creating second user: ${WP_USER_NAME}..."
  sudo -u nobody -E wp user create --path="${WP_PATH}" \
    "${WP_USER_NAME}" \
    "${WP_USER_EMAIL}" \
    --user_pass="${WP_USER_PASSWORD}" \
    --role="${WP_USER_ROLE}"
  log "Second user created."

else
  log "WordPress core is already installed."

  # Check if the second user exists, create if not (in case setup was interrupted)
  # Use wp user list which is slightly more robust than get for existence check
  # Run as 'nobody' user
  if ! sudo -u nobody -E wp user list --path="${WP_PATH}" --field=user_login | grep -q "^${WP_USER_NAME}$"; then
      log "Creating second user (post-install check): ${WP_USER_NAME}..."
      sudo -u nobody -E wp user create --path="${WP_PATH}" \
        "${WP_USER_NAME}" \
        "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role="${WP_USER_ROLE}"
      log "Second user created."
  else
      log "Second user (${WP_USER_NAME}) already exists."
  fi
fi

# --- Execute the CMD ---
log "Starting PHP-FPM..."
# Use exec to replace the script process with php-fpm
exec "$@"
