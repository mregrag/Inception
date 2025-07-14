FROM alpine:3.16

RUN apk update && apk add --no-cache nginx openssl

# Create directories
RUN mkdir -p /etc/nginx/ssl /var/run/nginx

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=MA/ST=Tanger-Tetouan-Al_Hoceima/L=Larache/O=42/OU=42Larache/CN=mregrag.42.ma"

COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
