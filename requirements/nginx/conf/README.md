# Nginx Configuration

## Navigation
- [⬆️ Nginx](../README.md)
- [⬆️⬆️ Requirements](../../README.md)
- [⬆️⬆️⬆️ Project Root](../../../README.md)
- [⬌ Tools](../tools/README.md)

This directory contains configuration files for the Nginx web server:

- **nginx.conf**: Main Nginx configuration file with global settings
- **default.conf.template**: Server block configuration template used to generate the final configuration

## Technical Details

### nginx.conf
- Configures Nginx with automatic worker process setting based on CPU cores
- Uses Docker-friendly logging (stdout/stderr)
- Includes performance optimizations:
  - Enables sendfile, tcp_nopush, tcp_nodelay
  - Configures gzip compression with optimal settings
  - Sets keepalive_timeout to 65 seconds
- Security enhancements:
  - Hides Nginx server version (server_tokens off)
  - Limited to TLSv1.2 and TLSv1.3 protocols
- Sets client_max_body_size to 64M to accommodate WordPress uploads
- Includes server block configs from /etc/nginx/conf.d/*.conf

### default.conf.template
- Template file used to generate server block configuration
- Dynamically configures the domain name using environment variables
