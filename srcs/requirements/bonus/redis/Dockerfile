FROM debian:bookworm

RUN apt-get update  && apt-get install -y redis-server

RUN \
    sed -i 's/^bind 127.0.0.1 .*/bind 0.0.0.0/' /etc/redis/redis.conf \
    && sed -i 's/^daemonize yes/daemonize no/' /etc/redis/redis.conf \
    && echo "aclfile /run/secrets/redis_acl" >> /etc/redis/redis.conf

CMD ["redis-server", "/etc/redis/redis.conf"]
