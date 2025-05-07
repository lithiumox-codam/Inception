FROM alpine:3.19

RUN apk update && \
    apk add --no-cache \
    mariadb \
    mariadb-client \
    bash

RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

RUN sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf

RUN echo "[mysqld]\nbind-address=0.0.0.0\nport=3306" > /etc/my.cnf.d/99-custom.cnf

COPY ./tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

VOLUME /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init.sh"]

CMD ["/usr/bin/mariadbd", "--user=mysql", "--console"]
