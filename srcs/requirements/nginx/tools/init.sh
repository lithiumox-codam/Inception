#!/bin/sh

set -e

if [ -z "${DOMAIN_NAME}" ]; then
  echo "Error: DOMAIN_NAME environment variable is not set."
  exit 1
fi

if [ ! -f /etc/nginx/ssl/nginx.crt ] || [ ! -f /etc/nginx/ssl/nginx.key ]; then
  echo "Generating self-signed SSL certificate for ${DOMAIN_NAME}..."
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=NL/ST=Amsterdam/L=Amsterdam/O=Codam/OU=mdekker/CN=${DOMAIN_NAME}"
  echo "SSL certificate generated."
else
  echo "SSL certificate already exists."
fi

echo "Substituting environment variables in Nginx config..."
envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf
echo "Nginx configuration updated."

echo "Starting Nginx..."
exec "$@"
