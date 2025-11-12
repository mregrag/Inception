FROM debian:bookworm-slim

RUN apt-get update && \ apt-get install -y wget ca-certificates 

# Download cAdvisor v0.53.0
RUN wget https://github.com/google/cadvisor/releases/download/v0.53.0/cadvisor-v0.53.0-linux-amd64 -O /usr/local/bin/cadvisor && \
    chmod +x /usr/local/bin/cadvisor


CMD ["/usr/local/bin/cadvisor", "-logtostderr"]
