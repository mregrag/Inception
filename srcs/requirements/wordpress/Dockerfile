FROM debian:bullseye

RUN apt-get update  -y && \
    apt-get install -y curl php php-fpm php-mysql mariadb-client && \
    mkdir -p /run/php && \
    sed -i 's|listen = .*|listen = 9000|' /etc/php/*/fpm/pool.d/www.conf

WORKDIR /var/www/html

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

ENTRYPOINT ["/usr/local/bin/setup.sh"]

