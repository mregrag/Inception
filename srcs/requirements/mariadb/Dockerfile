FROM debian:bookworm-slim 

RUN apt-get update && apt-get install -y mariadb-server

COPY ./tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld_safe", "--user=mysql", "--bind-address=0.0.0.0"]
