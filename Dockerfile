FROM tiredofit/nginx-php-fpm:7.2-latest
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Set Defaults
ENV FREESCOUT_VERSION=1.0.0

### Perform Installation
RUN set -x && \
	apk update && \
	apk upgrade && \
	apk add \
        expect \
        && \
    \
    mkdir -p /www/html && \
    curl -sSL https://github.com/freescout-helpdesk/freescout/archive/${FREESCOUT_VERSION}.tar.gz | tar xvfz - --strip 1 -C /www/html && \
    chown -R nginx:www-data /www/html && \
    \
### Cleanup
    sed -i -e "s#/www/html/index.php#/www/html/public/index.php#g" /etc/s6/services/10-nginx/run && \
    rm -rf /usr/src/* /var/tmp/* /var/cache/apk/*

### Assets
ADD install /
