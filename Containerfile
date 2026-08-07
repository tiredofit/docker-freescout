# SPDX-FileCopyrightText: © 2026 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL \
        org.opencontainers.image.title="FreeScout" \
        org.opencontainers.image.description="Containerized Helpdesk" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/freescout" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-freescout/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-freescout.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
    FREESCOUT_VERSION="1.8.233" \
    FREESCOUT_REPO_URL="https://github.com/freescout-helpdesk/freescout"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE      /usr/src/container/LICENSE
COPY README.md    /usr/src/container/README.md

COPY build-assets /build-assets

ENV \
    IMAGE_NAME="nfrastack/freescout" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-freescout/"

RUN echo "" && \
    BUILD_ENV=" \
                10-nginx/NGINX_SITE_ENABLED=freescout \
                20-php-fpm/PHP_MODULE_ENABLE_GNUPG=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_ICONV=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_IGBINARY=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_PCNTL=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_PDO_PGSQL=TRUE \
                30-laravel/APP_NAME=FreeScout \
                30-laravel/DB_TYPE=mysql \
                30-laravel/ENABLE_LARAVEL_WORKER=FALSE \
                30-laravel/LARAVEL_COMPOSER_SETUP=FALSE \
                30-laravel/LARAVEL_CONFIGURE_APP_KEY=TRUE \
                30-laravel/LARAVEL_CONFIGURE_DB=TRUE \
                30-laravel/LARAVEL_COPY_ENV_EXAMPLE=FALSE \
                30-laravel/LARAVEL_ENV_PREFIX=FREESCOUT_ \
                30-laravel/LARAVEL_IMAGE_MODE=production \
                30-laravel/LARAVEL_INSTALL_DATA_PATH=/container/data/freescout \
                30-laravel/LARAVEL_MIGRATE_ON_FIRST_INSTALL=FALSE \
                30-laravel/LARAVEL_NGINX_ENABLE_STATIC_PATHS=FALSE \
                30-laravel/LARAVEL_NPM_SETUP=FALSE \
              " \
              && \
    FREESCOUT_BUILD_DEPS_ALPINE=" \
                                " \
                                && \
    FREESCOUT_RUN_DEPS_ALPINE=" \
                                    expect \
                                    git \
                              " \
                              && \
    FREESCOUT_BUILD_DEPS_DEBIAN=" \
                                " \
                                && \
    FREESCOUT_RUN_DEPS_DEBIAN=" \
                                    expect \
                                    git \
                              " \
                              && \
    source /container/base/functions/container/build && \
    container_build_log image && \
    package update && \
    package upgrade && \
    package install \
                    FREESCOUT_BUILD_DEPS \
                    FREESCOUT_RUN_DEPS \
                    && \
    php-ext prepare && \
    php-ext reset && \
    php-ext enable core && \
    \
    clone_git_repo "${FREESCOUT_REPO_URL}" "${FREESCOUT_VERSION}" "${LARAVEL_INSTALL_DATA_PATH}"/install && \
    sed -i "s/env('APP_LOG', 'daily')/env('APP_LOG', 'single')/" "${LARAVEL_INSTALL_DATA_PATH}"/install/config/app.php && \
    cd "${LARAVEL_INSTALL_DATA_PATH}"/install && \
    build_assets /build-assets/src "${LARAVEL_INSTALL_DATA_PATH}"/install && \
    build_assets scripts && \
    mkdir -p \
                vendor/natxet/cssmin/src \
                vendor/rap2hpoutre/laravel-log-viewer/src/controllers && \
    composer install \
                    --ignore-platform-reqs \
                    --no-interaction \
                    --no-progress \
                    && \
    php artisan freescout:build && \
    rm -rf \
           "${LARAVEL_INSTALL_DATA_PATH}"/install/.editorconfig \
           "${LARAVEL_INSTALL_DATA_PATH}"/install/.env.travis \
           "${LARAVEL_INSTALL_DATA_PATH}"/install/.git* \
           "${LARAVEL_INSTALL_DATA_PATH}"/install/.htaccess \
           "${LARAVEL_INSTALL_DATA_PATH}"/install/.travis.yml \
           "${LARAVEL_INSTALL_DATA_PATH}"/install/tests \
           && \
    container_build_log add "FreeScout ${FREESCOUT_VERSION}" "${FREESCOUT_REPO_URL}" && \
    \
    package remove FREESCOUT_BUILD_DEPS && \
    package cleanup && \
    rm -rf \
           /build-assets

COPY rootfs /
