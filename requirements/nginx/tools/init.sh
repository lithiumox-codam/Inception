#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if DOMAIN_NAME is set
if [ -z "${DOMAIN_NAME}" ]; then
  echo "Error: DOMAIN_NAME environment variable is not set."
  exit 1
fi

# Generate self-signed SSL certificate if it doesn't exist
# Note: For production, use certificates from a trusted CA (e.g., Let's Encrypt)
if [ ! -f /etc/nginx/ssl/nginx.crt ] || [ ! -f /etc/nginx/ssl/nginx.key ]; then
  echo "Generating self-signed SSL certificate for ${DOMAIN_NAME}..."
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=student/CN=${DOMAIN_NAME}"
  echo "SSL certificate generated."
else
  echo "SSL certificate already exists."
fi

# Substitute environment variables in the Nginx config template
# Use envsubst to replace ${DOMAIN_NAME} with its actual value
echo "Substituting environment variables in Nginx config..."
envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf
echo "Nginx configuration updated."

# Execute the command passed as arguments to the script (CMD from Dockerfile)
echo "Starting Nginx..."
exec "$@"
