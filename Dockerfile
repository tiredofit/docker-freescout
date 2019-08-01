FROM tiredofit/alpine:edge
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Perform Installation
RUN set -x && \
	apk update && \
	apk upgrade && \
        \
	apk add \
            expect \
            gnu-libiconv \
            nginx \
            mariadb-client \
            openssl \
            php7-apcu \
            php7-bz2 \
            php7-cli \
            php7-ctype \
            php7-curl \
            php7-dom \
            php7-embed \
            php7-fileinfo \
            php7-fpm \
            php7-gd \
            php7-iconv \
            php7-imap \
            php7-json \
            php7-mbstring \
            php7-mysqli \
            php7-opcache \
            php7-openssl \
            php7-pdo \
            php7-pdo_mysql \
            php7-phar \
            php7-session \
            php7-simplexml \
            php7-tokenizer \
            php7-xml \
            php7-xmlrpc \
            php7-zip \
            php7-zlib \
        && \
    \
    ### Nginx and PHP7 Setup
    sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php7/php.ini && \
    ln -s /sbin/php-fpm7 /sbin/php-fpm && \
    \
    ### Install PHP Composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

### WWW  Installation
ADD freescout-install.sh /root/freescout-install.sh
ENTRYPOINT ["/root/freescout-install.sh"]

### Cleanup
RUN rm -rf /usr/src/* /var/tmp/* /var/cache/apk/*

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php7

### Networking Configuration
EXPOSE 80 

### Assets
ADD install /
