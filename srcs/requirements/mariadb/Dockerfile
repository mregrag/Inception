FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

# COPY ./conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/setup.sh"]
