FROM debian:bullseye

RUN apt-get update -y && apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf


COPY ./tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

ENTRYPOINT ["/usr/local/bin/setup.sh"]
