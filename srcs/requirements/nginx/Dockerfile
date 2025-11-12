FROM debian:bookworm-slim 

RUN apt-get update && apt-get install -y nginx 

COPY ./conf/wordpress.conf /etc/nginx/sites-available/wordpress.conf
COPY ./tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN rm -f /etc/nginx/sites-enabled/default \
    && ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/wordpress.conf \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
