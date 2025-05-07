# MariaDB Service

## Navigation
- [⬆️ Requirements](../README.md)
- [⬌ Nginx](../nginx/README.md)
- [⬌ WordPress](../wordpress/README.md)
- [⬇️ Tools](tools/README.md)

This directory contains files for setting up the MariaDB database container:

- **Dockerfile**: Defines the MariaDB container based on Alpine Linux
- **tools/init.sh**: Initialization script that configures MariaDB and creates the WordPress database and user

## Technical Details
- Based on Alpine Linux 3.21
- Exposes port 3306 for database connections
- Configured with networking enabled and bound to 0.0.0.0 to allow connections from other containers
- Uses a persistent volume for database storage
- CRITICAL: skip-networking is disabled in the main config file to allow remote connections

The MariaDB service provides the database backend for WordPress, configured to be accessible from other containers in the network.
