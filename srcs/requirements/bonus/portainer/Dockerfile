FROM debian:bookworm

RUN apt-get update && apt-get install -y wget tar ca-certificates

RUN wget https://github.com/portainer/portainer/releases/download/2.33.3/portainer-2.33.3-linux-amd64.tar.gz \
    && tar -xzf portainer-2.33.3-linux-amd64.tar.gz -C /usr/local/ \
    && rm portainer-2.33.3-linux-amd64.tar.gz

EXPOSE 8000 9443

VOLUME ["/data"]

CMD ["/usr/local/portainer/portainer", "--data=/data"]
