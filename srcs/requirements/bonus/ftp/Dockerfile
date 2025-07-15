FROM alpine:3.16

RUN apk update && apk add --no-cache vsftpd

# Add vsftpd.conf
COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 21 21000-21010

CMD ["/entrypoint.sh"]
