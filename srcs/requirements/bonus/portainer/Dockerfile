FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    wget \
    tar \
    ca-certificates

RUN mkdir /data

RUN wget https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz \
    && tar -xzf portainer-2.19.4-linux-amd64.tar.gz -C /usr/local \
    && mv /usr/local/portainer /usr/local/bin/ \
    && rm portainer-2.19.4-linux-amd64.tar.gz


COPY ./tools/start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
