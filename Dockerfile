FROM wichon/alpine-apache-php
RUN apk update \
    && apk add --no-cache autoconf openssl-dev php5-pear php5-dev gcc musl-dev make zlib-dev \
    && ln -s /usr/bin/php5 /usr/bin/php \
    && pecl config-set php_ini /etc/php5/php.ini \
    && pecl install mongo \
    && echo "extension=mongo.so" >> /etc/php5/php.ini \
    && apk del --purge autoconf gcc musl-dev make
    
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN sed -i 's/Listen 80/Listen 5000/g' /etc/apache2/httpd.conf
EXPOSE 5000
