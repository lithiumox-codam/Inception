# MariaDB Initialization Scripts

## Navigation
- [⬆️ MariaDB](../README.md)
- [⬆️⬆️ Requirements](../../README.md)
- [⬆️⬆️⬆️ Project Root](../../../README.md)

This directory contains initialization scripts for the MariaDB service:

- **init.sh**: Main initialization script for MariaDB database setup

## Technical Details

### init.sh functionality
- Sets up immediate exit on error (`set -e`)
- Uses "/var/lib/mysql" as the data directory
- Creates a marker file (.db_initialized) to track initialization status
- Verifies required environment variables (DB_ROOT_PASSWORD, DB_NAME, DB_USER, DB_PASSWORD)
- When first run:
  1. Initializes the MariaDB data directory
  2. Starts a temporary server bound to localhost for security
  3. Configures the database with root password
  4. Creates the WordPress database and user with appropriate permissions
  5. Shuts down the temporary server
- If the marker file exists, skips initialization
- Finally executes the command passed to the container
