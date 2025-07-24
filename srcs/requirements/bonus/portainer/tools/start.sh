#!/bin/bash

ADMIN_PASSWORD=$(cat /run/secrets/portainer_admin_password)

echo "$ADMIN_PASSWORD" > /tmp/portainer_password

exec /usr/local/bin/portainer/portainer \
  --bind 0.0.0.0:9000 \
  --data /data \
  --admin-password-file /tmp/portainer_password
