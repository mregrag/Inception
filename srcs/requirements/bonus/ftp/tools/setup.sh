#!/bin/bash
set -e

useradd -m "$FTP_USER"
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
mkdir -p /var/run/vsftpd/empty

# This must be done at runtime (not at image build)
chown -R "$FTP_USER:$FTP_USER" /var/www/html

exec /usr/sbin/vsftpd /etc/vsftpd.conf
