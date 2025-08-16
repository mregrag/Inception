#!/bin/bash

set -e

cp /run/secrets/nginx_cert /etc/nginx/ssl/nginx.crt
cp /run/secrets/nginx_key /etc/nginx/ssl/nginx.key

exec nginx -g "daemon off;"
