FROM debian:bookworm

RUN apt-get update -y && apt-get install -y curl php php-mysqli

RUN mkdir -p /var/www/adminer

RUN curl -sSL "https://www.adminer.org/latest.php" -o /var/www/adminer/index.php

CMD ["php", "-S", "0.0.0.0:9090", "-t", "/var/www/adminer"]
