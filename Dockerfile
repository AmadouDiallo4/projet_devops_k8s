FROM php:7.3-apache



RUN apt-get update \
    && apt-get install -y wget unzip

RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++

RUN docker-php-ext-configure intl && docker-php-ext-install intl

RUN docker-php-ext-install mysqli

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN wget -O /usr/src/dolibarr.zip https://github.com/Dolibarr/dolibarr/archive/10.0.3.zip

WORKDIR /var/www

RUN unzip /usr/src/dolibarr.zip -d /usr/src/ \
	&& rm /usr/src/dolibarr.zip \
	&& rm -rf /var/www/html \
	&& mv /usr/src/dolibarr-10.0.3 /var/www/html/ \ 
	&& chown -R www-data:www-data /var/www/html/ \
	&& chmod -R 755 /var/www/html/


RUN sed -i 's|DocumentRoot.*|DocumentRoot /var/www/html/htdocs|' /etc/apache2/sites-enabled/000-default.conf


CMD touch /var/www/html/htdocs/conf/conf.php \
 && chown www-data /var/www/html/htdocs/conf/conf.php \
 && apache2-foreground
