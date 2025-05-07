# WordPress Initialization Scripts

## Navigation
- [⬆️ WordPress](../README.md)
- [⬆️⬆️ Requirements](../../README.md)
- [⬆️⬆️⬆️ Project Root](../../../README.md)
- [⬌ Configuration](../conf/README.md)

This directory contains initialization scripts for the WordPress service:

- **init.sh**: Main initialization script that sets up and configures WordPress

## Technical Details

### init.sh functionality
- Sets up immediate exit on error (`set -e`)
- Uses key configuration paths:
  - WP_PATH="/var/www/html" (WordPress installation directory)
  - WP_SOURCE_DIR="/usr/src/wordpress" (Source files location)
  - WP_CONFIG_FILE="${WP_PATH}/wp-config.php" (WordPress configuration file)
- Verifies all required environment variables:
  - Database settings: DB_HOST, DB_USER, DB_PASSWORD, DB_NAME
  - WordPress admin: WP_ADMIN_USER, WP_ADMIN_PASSWORD, WP_ADMIN_EMAIL
  - Secondary user: WP_USER_NAME, WP_USER_PASSWORD, WP_USER_EMAIL, WP_USER_ROLE
  - Domain configuration: DOMAIN_NAME
- Copies WordPress files from the image source directory to the volume mount if empty
- Sets correct ownership to 'nobody:nobody' for WordPress files
- Waits up to 30 seconds for the database connection before timing out
- Creates wp-config.php if it doesn't exist with proper database settings
- Sets direct filesystem method for plugin/theme installations
- Installs WordPress core if not already installed
- Creates admin user and secondary user accounts
- Ensures the secondary user exists even if installation was previously interrupted
- Finally executes the command passed to the container (typically PHP-FPM)
