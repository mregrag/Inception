FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx

COPY ./conf/wordpress.conf /etc/nginx/sites-available/wordpress.conf

RUN rm -f /etc/nginx/sites-enabled/default

RUN ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/default

COPY ./tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
