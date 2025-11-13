#!/bin/bash
set -e

ADMIN_PASSWORD_FILE="/run/secrets/portainer_admin_password"

if [ ! -s "$ADMIN_PASSWORD_FILE" ]; then
    echo "portainer_admin_password secret file is empty"
    exit 1
fi

exec /usr/local/portainer/portainer --admin-password-file "$ADMIN_PASSWORD_FILE"
