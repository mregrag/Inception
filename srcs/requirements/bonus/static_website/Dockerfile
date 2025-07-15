FROM alpine:3.16

RUN apk add --no-cache nginx

COPY ./tools/website/ /usr/share/nginx/html/

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx","-g","daemon off;"]
