FROM debian:bookworm-slim 

RUN apt-get update && apt-get install -y nginx

COPY ./conf/website.conf /etc/nginx/sites-available/website.conf

COPY ./conf/html/ /var/www/html/

RUN rm -f /etc/nginx/sites-enabled/default \
    && ln -s /etc/nginx/sites-available/website.conf /etc/nginx/sites-enabled/website.conf

CMD ["nginx", "-g", "daemon off;"]
