FROM debian:bullseye

RUN apt-get update -y && apt-get install -y curl php php-mysqli

RUN mkdir -p /var/www/html && \
    curl -sSL "https://www.adminer.org/latest.php" -o /var/www/html/index.php && \
    chown -R www-data:www-data /var/www/html

ENTRYPOINT ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
