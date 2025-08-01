FROM debian:bullseye

RUN apt-get update -y && apt-get install nginx -y

COPY ./tools/website/ /usr/share/nginx/html/
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx","-g","daemon off;"]
