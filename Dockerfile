# FROM wichon/alpine-apache-php
FROM alpine:3.7

# Install gnu-libconv required by php5-iconv
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

# Setup apache and php
RUN apk --update add apache2 php5-apache2 curl \
    php5-json php5-phar php5-openssl php5-mysql php5-curl php5-mcrypt php5-pdo_mysql php5-ctype php5-gd php5-xml php5-dom php5-iconv \
    && rm -f /var/cache/apk/* \
    && mkdir /run/apache2 \
    && mkdir -p /opt/utils  

ADD start.sh /opt/utils/
RUN chmod +x /opt/utils/start.sh

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

ENTRYPOINT ["/opt/utils/start.sh"]
