ARG PHP_VERSION=8.3

# ============================================
# Stage: PHP-FPM + Nginx 一体化镜像
# ============================================
FROM php:${PHP_VERSION}-fpm-alpine

LABEL maintainer="elijah-hall-asdq1"
LABEL org.opencontainers.image.source="https://github.com/elijah-hall-asdq1/Ultimate-PHP-Docker"
LABEL org.opencontainers.image.description="Nginx + PHP-FPM Docker Image for ThinkPHP & Laravel"

# 安装系统依赖 + PHP 扩展
RUN apk add --no-cache \
        nginx \
        supervisor \
        curl \
        zip \
        unzip \
        git \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        libzip-dev \
        icu-dev \
        oniguruma-dev \
        libxml2-dev \
        linux-headers \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mysqli \
        gd \
        zip \
        bcmath \
        opcache \
        intl \
        mbstring \
        xml \
        pcntl \
        sockets \
    # 安装 Redis 扩展
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps \
    # 清理缓存
    && rm -rf /var/cache/apk/* /tmp/*

# 安装 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 复制配置文件
COPY config/nginx.conf /etc/nginx/http.d/default.conf
COPY config/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY config/supervisord.conf /etc/supervisord.conf

# 创建工作目录并设置权限
RUN mkdir -p /var/www/html /run/nginx \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# 创建默认 index.php
RUN echo '<?php phpinfo();' > /var/www/html/index.php \
    && chown www-data:www-data /var/www/html/index.php

WORKDIR /var/www/html

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
