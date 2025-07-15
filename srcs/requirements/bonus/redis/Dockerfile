FROM alpine:3.16

RUN apk update && apk add --no-cache redis && \
    mkdir -p /data

COPY ./conf/redis.conf /etc/redis/redis.conf

EXPOSE 6379

# Use Redis server as PID 1 (following best practices)
CMD ["redis-server", "/etc/redis/redis.conf"]
