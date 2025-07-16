FROM alpine:3.16

RUN apk update && apk add --no-cache \
	php8 \
	php8-session \
	php8-mysqli \
	wget

RUN mkdir -p /var/www/html && \
	wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -O /var/www/html/index.php && \
	chmod 644 /var/www/html/index.php

EXPOSE 8080

ENTRYPOINT ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
