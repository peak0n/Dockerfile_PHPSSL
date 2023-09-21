# Use the official Debian 11 (Bullseye) slim image as the base image.
FROM debian:12-slim

# Install PHP 8 and Apache 2 along with necessary PHP extensions and tools.
RUN apt-get update && \
    apt-get install -y \
        apache2 \
        php \
        libapache2-mod-php \
        php-mysql \
        php-gd \
        php-curl \
        php-xml \
        php-mbstring \
        php-zip \
        php-intl \
        php-bcmath \
        php-json \
        php-opcache \
        php-iconv \
        php-soap \
        curl \
        git \
        unzip

RUN rm -rf /var/lib/apt/lists/*

# Enable the Apache rewrite module.
RUN a2enmod ssl
RUN a2enmod rewrite


RUN rm -rf /var/www/html/*

WORKDIR /var/www/html

RUN chown -R www-data:www-data /var/www/html



# Configure PHP-FPM
ENV PHP_INI_DIR /etc/php/8.2/apache2

#COPY config/php.ini ${PHP_INI_DIR}/conf.d/custom.ini
RUN echo "max_input_vars = 5000" >> ${PHP_INI_DIR}/conf.d/custom.ini


COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

#RUN a2ensite default-ssl
RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2enmod rewrite ssl

# Expose port 443 for HTTPS
#EXPOSE 80
EXPOSE 443


# Start the Apache web server in the foreground.
CMD ["apachectl", "-D", "FOREGROUND"]