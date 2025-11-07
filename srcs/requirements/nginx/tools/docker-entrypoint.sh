#!/bin/bash

set -e

CERT_CONTENT=$(cat /run/secrets/nginx_cert)
KEY_CONTENT=$(cat /run/secrets/nginx_key)

: "${DOMAIN_NAME:?DOMAIN_NAME environment variable is not set}"

if [ -z "$CERT_CONTENT" ]; then
    echo "nginx_cert secret file is empty"
    exit 1
fi

if [ -z "$KEY_CONTENT" ]; then
    echo "nginx_key secret file is empty"
    exit 1
fi

sed -i "s|DOMAIN_NAME|$DOMAIN_NAME|g" /etc/nginx/sites-available/wordpress.conf

echo "Starting NGINX"

exec "$@"
