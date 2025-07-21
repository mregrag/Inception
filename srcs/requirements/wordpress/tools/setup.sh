#!/bin/bash

# Read passwords from Docker secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_password)
WP_USER_PASS=$(cat /run/secrets/wp_user_password)

if [ ! -f "/var/www/html/wp-config.php" ]; then
    wp core download --allow-root

    wp config create --allow-root \
	--dbname=$MYSQL_DATABASE \
	--dbuser=$MYSQL_USER \
	--dbpass=$DB_PASSWORD \
	--dbhost=$MYSQL_SERVER \
	--path=/var/www/html

    wp core install --allow-root \
	--url=$DOMAIN_NAME \
	--title=$WP_TITLE \
	--admin_user=$WP_ADMIN_USER \
	--admin_password=$WP_ADMIN_PASS \
	--admin_email=$WP_ADMIN_EMAIL

    wp user create --allow-root \
	$WP_USER \
	$WP_EMAIL \
	--user_pass=$WP_USER_PASS \
	--role=author

    wp theme install twentytwentyfour --activate --allow-root

    wp plugin install redis-cache --activate --allow-root
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp redis enable --allow-root

    chown -R www-data:www-data /var/www/html
fi

exec php-fpm7.4 -F
