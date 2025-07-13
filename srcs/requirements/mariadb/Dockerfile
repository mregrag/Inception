FROM alpine:3.16

RUN apk update && apk add --no-cache mariadb mariadb-client

# Create directories
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Copy configuration files
COPY ./conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY ./tools/setup.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
