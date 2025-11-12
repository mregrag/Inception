#!/bin/sh

set -e

REDIS_PASSWORD=$(cat /run/secrets/redis_password)
if [ -z "$REDIS_PASSWORD" ]; then echo "redis_password secret is empty"; exit 1; fi

REDIS_CONF="/etc/redis/redis.conf"

sed -i 's/^bind 127.0.0.1 .*/bind 0.0.0.0/' "$REDIS_CONF"

sed -i 's/^daemonize yes/daemonize no/' "$REDIS_CONF"

echo "requirepass $REDIS_PASSWORD" > "$REDIS_CONF"

exec "$@" "$REDIS_CONF"

