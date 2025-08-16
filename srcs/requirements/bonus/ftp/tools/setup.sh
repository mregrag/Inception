#!/bin/bash

set -e

if [ ! -s "/run/secrets/ftp_password" ] || [ ! -r "/run/secrets/ftp_password" ]; then
    echo "Error: FTP password secret file is missing, empty, or not readable" >&2
    exit 1
fi


FTP_PASSWORD=$(cat "/run/secrets/ftp_password")

if [ -z "$FTP_USER" ]; then
    echo "Error: FTP_USER is not set or empty" >&2
    exit 1
fi


if id "$FTP_USER" &>/dev/null; then
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
else
    useradd -m "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

mkdir -p /var/run/vsftpd/empty

chown -R "$FTP_USER:$FTP_USER" /var/www/html

exec /usr/sbin/vsftpd /etc/vsftpd.conf
