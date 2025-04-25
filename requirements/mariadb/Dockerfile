FROM alpine:3.21

# Install MariaDB server and client packages
RUN apk update && \
    apk add --no-cache \
    mariadb \
    mariadb-client \
    bash

# Create necessary directories for MariaDB data and runtime files
RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

# CRITICAL: Simply comment out skip-networking in the main config file
RUN sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf

# Create a simple override config 
RUN echo "[mysqld]\nbind-address=0.0.0.0\nport=3306" > /etc/my.cnf.d/99-custom.cnf

# Copy the entrypoint script and make it executable
COPY ./tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Define the data directory as a volume for persistence
VOLUME /var/lib/mysql

# Expose the default MariaDB port
EXPOSE 3306

# Set the entrypoint script
ENTRYPOINT ["/usr/local/bin/init.sh"]

# Basic command without extra options (handled by config)
CMD ["/usr/bin/mariadbd", "--user=mysql", "--console"]
