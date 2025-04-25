# WordPress PHP-FPM Configuration

## Navigation
- [⬆️ WordPress](../README.md)
- [⬆️⬆️ Requirements](../../README.md)
- [⬆️⬆️⬆️ Project Root](../../../README.md)
- [⬌ Tools](../tools/README.md)

This directory contains the PHP-FPM configuration for the WordPress service:

- **www.conf**: PHP-FPM pool configuration file

## Technical Details

### www.conf configuration
- Uses `nobody` user and group for PHP-FPM processes (standard non-root user in Alpine)
- Configured to listen on all network interfaces (0.0.0.0:9000) to allow connections from Nginx
- Process manager settings:
  - Dynamic mode with maximum 5 concurrent PHP processes
  - 2 processes started when FPM launches
  - 1-3 idle processes maintained to handle requests
- Docker-compatible logging configuration:
  - Worker errors sent to main FPM error log stream
  - PHP errors directed to stderr for capture by Docker logs
  - Access logs sent to stdout
- Prevents FPM from clearing environment variables to ensure Docker environment variables remain available
- Can be extended with custom PHP settings like memory_limit, upload_max_filesize, and post_max_size
