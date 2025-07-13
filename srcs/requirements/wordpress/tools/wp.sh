#! /bin/bash

echo "⏳ Waiting for MariaDB at $MYSQL_HOSTNAME:3306 …"
while ! mysqladmin ping -h"$MYSQL_HOSTNAME" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    sleep 2
done
echo "MariaDB is up"

if [ -f ./wp-config.php ]
then
	echo "Wordpress already exists"
else
	wp core download --allow-root
	wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOSTNAME --allow-root
	wp core install --url=$DONAIN_NAME --title="$WORDPRESS_TITLE" --admin_user=$WORDPRESS_ADMIM --admin_password=$WORDPRESS_ADMIM_PASS  --admin_email=$WORDPRESS_ADMIM_EMAIL --skip-email --allow-root
	wp user create $WORDPRESS_USER $WORDPRESS_EMAIL --role=author --user_pass=$WORDPRESS_USER_PASS --allow-root
	wp theme install twentysixteen --activate --allow-root
fi

/usr/sbin/php-fpm7.4 -F;
