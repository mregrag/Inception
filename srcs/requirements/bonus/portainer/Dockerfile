FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y wget tar ca-certificates

RUN wget https://github.com/portainer/portainer/releases/download/2.33.3/portainer-2.33.3-linux-amd64.tar.gz \
    && tar -xzf portainer-2.33.3-linux-amd64.tar.gz -C /usr/local/ \
    && ln -s /usr/local/portainer/portainer /usr/local/bin/portainer-server \
    && rm portainer-2.33.3-linux-amd64.tar.gz

COPY ./tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
