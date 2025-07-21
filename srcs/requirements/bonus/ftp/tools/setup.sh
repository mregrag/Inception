#!/bin/bash
set -e

FTP_PASSWORD=$(cat /run/secrets/ftp_password)

useradd -m "$FTP_USER"
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
mkdir -p /var/run/vsftpd/empty

chown -R "$FTP_USER:$FTP_USER" /var/www/html

exec /usr/sbin/vsftpd /etc/vsftpd.conf
