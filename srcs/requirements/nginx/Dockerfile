FROM alpine:3.19

RUN apk update && \
    apk add --no-cache \
    nginx \
    gettext \
    openssl

RUN mkdir -p /etc/nginx/ssl /etc/nginx/templates /etc/nginx/conf.d

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

COPY ./conf/default.conf.template /etc/nginx/templates/default.conf.template

COPY ./tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/init.sh"]

CMD ["nginx", "-g", "daemon off;"]
