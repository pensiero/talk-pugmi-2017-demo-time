FROM ubuntu:16.04

ENV PROJECT_PATH=/var/www \
    DEBIAN_FRONTEND=noninteractive \
    APACHE_PID_FILE=/var/run/apache2/apache2.pid \
    PHP_INI=/etc/php/7.0/apache2/php.ini \
    TERM=xterm

RUN apt-get update -q && apt-get upgrade -yqq && apt-get install -yqq --force-yes \
    curl \
    git \
    zip \
    apache2 \
    libapache2-mod-php \
    php \
    php-curl \
    php-mysql

RUN a2enmod rewrite expires headers

RUN sed -i "s/short_open_tag = .*/short_open_tag = On/" $PHP_INI

RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
RUN a2enconf fqdn

EXPOSE 80

COPY config/apache-virtualhost.conf /etc/apache2/sites-available/000-default.conf

COPY . $PROJECT_PATH
WORKDIR $PROJECT_PATH

CMD rm -f $APACHE_PID_FILE && /usr/sbin/apache2ctl -D FOREGROUND