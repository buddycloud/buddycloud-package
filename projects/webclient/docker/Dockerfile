# Ubuntu/precise is the main distribution
FROM ubuntu:precise

# sanitize all package lists
RUN echo > /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list

# add wget and apache2
RUN rm -rvf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl
RUN apt-get install --no-install-recommends -y software-properties-common python-software-properties
RUN apt-add-repository ppa:ondrej/apache2
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget apache2

ADD webclient.deb /tmp/webclient.deb
RUN dpkg -i /tmp/webclient.deb | true
ADD buddycloud.net /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf
ADD config.js /usr/share/buddycloud-webclient/config.js

RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_wstunnel
RUN a2enmod ssl
RUN a2enmod headers
RUN a2enmod expires
RUN a2enmod rewrite
ADD replace-api-hosting-vars /tmp/replace-api-hosting-vars
RUN mkdir -p /etc/apache2/certs/;rm /etc/apache2/conf-enabled/*

ENTRYPOINT mkdir -p /var/run/apache2; ln -s /srv/secret/buddycloud.com.pem /etc/apache2/certs/buddycloud.com.pem;/tmp/replace-api-hosting-vars; ls /etc/apache2/sites-enabled; tail -F /var/log/apache2/*.log & apache2ctl -D FOREGROUND
EXPOSE 80 443
