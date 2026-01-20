FROM prestashop/prestashop:1.7.8

USER root

COPY ./html/themes /var/www/html/themes
COPY ./html/modules /var/www/html/modules
COPY ./html/override /var/www/html/override

RUN docker-php-ext-enable opcache && \
    echo "opcache.enable=1" >> /usr/local/etc/php/conf. d/opcache.ini && \
    echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.interned_strings_buffer=8" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache. max_accelerated_files=4000" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.revalidate_freq=60" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.fast_shutdown=1" >> /usr/local/etc/php/conf. d/opcache.ini

RUN a2enmod rewrite headers expires

COPY apache-prestashop.conf /etc/apache2/sites-enabled/000-default.conf

COPY htaccess_prestashop /var/www/html/.htaccess

COPY parameters.php /var/www/html/app/config/parameters.php

RUN chown -R www-data:www-data /var/www/html && \
    chmod 644 /var/www/html/app/config/parameters.php && \
    chmod 644 /var/www/html/.htaccess

USER www-data
EXPOSE 80
ENTRYPOINT ["docker-php-entrypoint"]
CMD ["apache2-foreground"]
