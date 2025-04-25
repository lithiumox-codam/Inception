# Inception Project

This project sets up a complete WordPress environment using Docker containers. The architecture consists of three main services:

1. **Nginx**: Acts as a web server and reverse proxy, handling HTTPS connections on port 443
2. **WordPress**: Runs the WordPress application with PHP-FPM
3. **MariaDB**: Provides the database backend for WordPress

## Navigation
- [Requirements Directory](requirements/README.md)
  - [MariaDB Configuration](requirements/mariadb/README.md)
  - [Nginx Configuration](requirements/nginx/README.md)
  - [WordPress Configuration](requirements/wordpress/README.md)

## Project Structure

- **docker-compose.yml**: Orchestrates the three services and their connections
- **Makefile**: Provides convenient commands to build, run, and manage the Docker environment
- **requirements/**: Contains configuration for each service
  - **mariadb/**: MariaDB database service configuration
  - **nginx/**: Nginx web server configuration
  - **wordpress/**: WordPress application configuration

## Getting Started

1. Create an `.env` file based on `.env.example` with your custom settings
2. Run `make` to build and start all containers
3. Access the WordPress site at https://mdekker.42.fr

For more commands, run `make help`
