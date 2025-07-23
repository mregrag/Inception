#!/bin/bash

exec /usr/local/bin/portainer/portainer \
  --bind 0.0.0.0:9000 \
  --data /data \
  --admin-password-file /tmp/portainer_password
