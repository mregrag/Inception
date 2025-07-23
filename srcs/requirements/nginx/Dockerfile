FROM debian:bullseye

RUN apt-get update -y && apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf


COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
