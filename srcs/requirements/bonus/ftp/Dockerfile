FROM debian:bookworm

RUN apt-get update && apt-get install -y vsftpd

COPY ./conf/vsftpd.conf /etc/vsftpd.conf

COPY ./tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /var/run/vsftpd/empty
RUN echo "/usr/sbin/nologin" >> /etc/shells

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["vsftpd", "/etc/vsftpd.conf"]
