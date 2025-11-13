#!/bin/bash

set -e

FTP_PASSWORD=$(cat /run/secrets/ftp_user_password)

if [ -z "$FTP_PASSWORD" ]; then echo "ftp_password secret file is empty"; exit 1; fi

: "${FTP_USER:?FTP_USER environment variable is not set}"


if ! id -u "$FTP_USER" >/dev/null 2>&1; then
    useradd -d /var/www/html -g 33 "$FTP_USER"

echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

echo "$FTP_USER" > /etc/vsftpd.userlist

exec "$@"
