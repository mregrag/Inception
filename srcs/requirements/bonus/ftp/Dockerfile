FROM debian:bullseye

RUN apt-get update && apt-get install -y vsftpd

COPY ./conf/vsftpd.conf /etc/vsftpd.conf
COPY ./tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 21 21000-21010

CMD ["/setup.sh"]

