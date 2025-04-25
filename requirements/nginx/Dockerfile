FROM alpine:3.21

# Arguments passed from docker-compose build
# ARG DOMAIN_NAME # This ARG isn't used by the runtime init.sh

# Install Nginx, OpenSSL (for certs), and envsubst (for config templating)
RUN apk update && \
    apk add --no-cache \
    nginx \
    gettext \
    openssl

# Create directories for SSL certificates, Nginx config template, and runtime config
RUN mkdir -p /etc/nginx/ssl /etc/nginx/templates /etc/nginx/conf.d

# Copy the custom main Nginx configuration file, overwriting the default
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Copy the Nginx server block configuration template
COPY ./conf/default.conf.template /etc/nginx/templates/default.conf.template

# Copy the entrypoint script and make it executable
COPY ./tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Expose ONLY the HTTPS port
EXPOSE 443

# Set the init script to run on container start
ENTRYPOINT ["/usr/local/bin/init.sh"]

# Default command (will be executed by the init script)
# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
