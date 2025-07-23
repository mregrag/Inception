#!/bin/bash

cp /run/secrets/nginx_cert /etc/nginx/ssl/nginx.crt
cp /run/secrets/nginx_key /etc/nginx/ssl/nginx.key

chmod 600 /etc/nginx/ssl/nginx.key #private
chmod 644 /etc/nginx/ssl/nginx.crt #public

exec "$@"
