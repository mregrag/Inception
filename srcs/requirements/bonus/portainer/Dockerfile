FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y wget tar ca-certificates

COPY ./tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN wget https://github.com/portainer/portainer/releases/download/2.33.3/portainer-2.33.3-linux-amd64.tar.gz -O /tmp/portainer.tar.gz \
    && tar -xzf /tmp/portainer.tar.gz -C /usr/local/ \
    && rm /tmp/portainer.tar.gz

ENTRYPOINT ["docker-entrypoint.sh"]
