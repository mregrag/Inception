#!/bin/bash

set -e

FTP_PASSWORD=$(cat /run/secrets/ftp_user_password)

: "${FTP_USER:?FTP_USER environment variable is not set}"

if [ -z "$FTP_PASSWORD" ]; then echo "ftp_password secret file is empty"; exit 1; fi

if ! id -u "$FTP_USER" >/dev/null 2>&1; then
    echo "Creating FTP user $FTP_USER"
    useradd -d /var/www/html -g 33 "$FTP_USER"
else
    echo "FTP user $FTP_USER already exists"
fi

echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

echo "$FTP_USER" > /etc/vsftpd.userlist

echo "Starting FTP Server"

exec "$@"
