# Nginx Service

## Navigation
- [⬆️ Requirements](../README.md)
- [⬌ MariaDB](../mariadb/README.md)
- [⬌ WordPress](../wordpress/README.md)
- [⬇️ Configuration](conf/README.md)
- [⬇️ Tools](tools/README.md)

This directory contains files for setting up the Nginx web server container:

- **Dockerfile**: Defines the Nginx container based on Alpine Linux
- **conf/**: Contains Nginx configuration files
  - **nginx.conf**: Main Nginx configuration
  - **default.conf.template**: Server block configuration template
- **tools/init.sh**: Initialization script that sets up SSL certificates and prepares Nginx configuration

## Technical Details
- Based on Alpine Linux 3.21
- Exposes only port 443 for HTTPS connections
- Uses OpenSSL for SSL certificate generation
- Uses environment variable templating with envsubst for dynamic configuration
- Creates SSL certificates during container initialization
- Runs Nginx in foreground mode with daemon off

The Nginx service acts as a web server and reverse proxy, handling HTTPS connections on port 443 and forwarding requests to the WordPress service.
