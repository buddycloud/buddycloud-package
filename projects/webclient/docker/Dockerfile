# Ubuntu/precise is the main distribution
FROM ubuntu:precise

# sanitize all package lists
RUN echo > /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list

# add wget and java
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget openssl apache2

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

ADD webclient.deb /tmp/webclient.deb
RUN dpkg -i /tmp/webclient.deb
ADD buddycloud.net /etc/apache2/sites-enabled/default
ADD config.js /usr/share/buddycloud-webclient/config.js

RUN a2dissite buddycloud-apache-virtual-host; rm /etc/apache2/sites-available/buddycloud-apache-virtual-host
RUN a2enmod rewrite
RUN a2enmod proxy
ADD replace-api-hosting-vars /tmp/replace-api-hosting-vars

ENTRYPOINT mkdir -p /var/run/apache2; /tmp/replace-api-hosting-vars; ls /etc/apache2/sites-enabled; apache2ctl graceful; apache2ctl -D FOREGROUND
EXPOSE 80 443
