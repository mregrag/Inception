#!/bin/sh

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
    
    echo "Creating wp-config.php..."
    wp config create \
        --dbname=${WORDPRESS_DB_NAME} \
        --dbuser=${WORDPRESS_DB_USER} \
        --dbpass=${WORDPRESS_DB_PASSWORD} \
        --dbhost=${WORDPRESS_DB_HOST} \
        --dbprefix=${WORDPRESS_TABLE_PREFIX} \
        --allow-root
    
    # Install WordPress
    echo "Installing WordPress..."
    wp core install \
        --url=${DOMAIN_NAME} \
        --title="Inception WordPress" \
        --admin_user=${WORDPRESS_ADMIN_USER} \
        --admin_password=${WORDPRESS_ADMIN_PASSWORD} \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --allow-root
    
    echo "Creating regular user..."
    wp user create ${WORDPRESS_USER} ${WORDPRESS_USER_EMAIL} \
        --user_pass=${WORDPRESS_USER_PASSWORD} \
        --role=author \
        --allow-root

    # Add Redis configuration to wp-config.php
    wp config set WP_REDIS_HOST "${REDIS_HOST}" --allow-root
    wp config set WP_REDIS_PORT "${REDIS_PORT}" --allow-root
    wp config set WP_REDIS_PASSWORD "${REDIS_PASSWORD}" --allow-root
    wp config set WP_CACHE true --allow-root
    wp config set WP_REDIS_CLIENT phpredis --allow-root

    wp plugin activate redis-cache --allow-root
    wp redis enable --allow-root

    echo "WordPress Redis cache configured successfully!"
fi

chown -R nobody:nobody /var/www/html
exec php-fpm8 -F
