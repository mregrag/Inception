#!/bin/bash

ADMIN_PASSWORD=$(cat /run/secrets/portainer_admin_password)

if [ -z "$ADMIN_PASSWORD" ]; then
    echo "portainer_admin_password secret file is empty"
    exit 1
fi

exec portainer-server --admin-password=ADMIN_PASSWORD
