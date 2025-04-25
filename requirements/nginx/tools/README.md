# Nginx Initialization Scripts

## Navigation
- [⬆️ Nginx](../README.md)
- [⬆️⬆️ Requirements](../../README.md)
- [⬆️⬆️⬆️ Project Root](../../../README.md)
- [⬌ Configuration](../conf/README.md)

This directory contains initialization scripts for the Nginx service:

- **init.sh**: Main initialization script that sets up SSL certificates and prepares Nginx configuration

## Technical Details

### init.sh functionality
- Sets up immediate exit on error (`set -e`)
- Verifies the DOMAIN_NAME environment variable is set
- Generates a self-signed SSL certificate for HTTPS if one doesn't exist
  - For production environments, you should replace with certificates from a trusted CA like Let's Encrypt
- Uses envsubst to substitute environment variables in the Nginx config template
- Converts the default.conf.template into the final default.conf by replacing ${DOMAIN_NAME}
- Finally executes the command passed to the container (typically starting Nginx)
