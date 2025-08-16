FROM debian:bullseye

RUN apt-get update -y && apt-get install -y curl php php-mysqli

RUN mkdir -p /var/www/html && \
    curl -sSL "https://www.adminer.org/latest.php" -o /var/www/html/adminer.php && \

ENTRYPOINT ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
