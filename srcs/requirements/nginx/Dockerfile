FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl curl

COPY conf/default /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

COPY tools/ssl_setup.sh /usr/local/bin/ssl_setup.sh
RUN chmod +x /usr/local/bin/ssl_setup.sh

EXPOSE 443

CMD ["/usr/local/bin/ssl_setup.sh"]
