FROM debian:bookworm-slim 

RUN apt-get update && apt-get install -y php-fpm php-mysqli curl mariadb-client

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && sed -i 's|listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

COPY ./tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && mkdir -p /var/www/html

WORKDIR /var/www/html

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm8.2", "-F"]
