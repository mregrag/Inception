#!/bin/sh
set -e

adduser -D -h /var/www/html -s /bin/false "$FTP_USER"
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
