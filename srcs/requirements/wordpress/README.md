# WordPress Service

## Navigation
- [⬆️ Requirements](../README.md)
- [⬌ MariaDB](../mariadb/README.md)
- [⬌ Nginx](../nginx/README.md)
- [⬇️ Configuration](conf/README.md)
- [⬇️ Tools](tools/README.md)

This directory contains files for setting up the WordPress container:

- **Dockerfile**: Defines the WordPress container based on Alpine Linux with PHP-FPM
- **conf/www.conf**: PHP-FPM pool configuration
- **tools/init.sh**: Initialization script that configures WordPress and installs it if needed

## Technical Details
- Based on Alpine Linux 3.21
- Uses PHP 8.2 with FPM for running WordPress
- WordPress version can be set via build argument (defaults to 'latest')
- PHP-FPM is configured to run in non-daemon mode with error logging to stderr
- Environment variables:
  - WP_PATH: /var/www/html (mount point for WordPress files)
  - WP_SOURCE_DIR: /usr/src/wordpress (location of WordPress source in container)
- Includes WP-CLI for WordPress management
- Exposes port 9000 for communication with Nginx
- Uses PHP symbolic link (php82 -> php) for compatibility
- Core WordPress files are downloaded during image build
- The entrypoint script populates the volume mount from source files if empty

The WordPress service runs the WordPress application with PHP-FPM, connecting to the MariaDB database and being served by Nginx.
