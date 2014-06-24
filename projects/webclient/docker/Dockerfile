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

RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_wstunnel
RUN a2enmod ssl
RUN a2enmod headers
RUN a2enmod expires
RUN a2enmod rewrite
ADD replace-api-hosting-vars /tmp/replace-api-hosting-vars
ADD apache2.conf /etc/apache2/apache2.conf
RUN mkdir -p /etc/apache2/certs/
RUN touch /etc/apache2/sites-available/buddycloud-apache-virtual-host; ln -s /etc/apache2/sites-available/buddycloud-apache-virtual-host /etc/apache2/sites-available/buddycloud-apache-virtual-host.conf
RUN service apache2 restart

ADD webclient.deb /tmp/webclient.deb
RUN dpkg -i --force-confnew /tmp/webclient.deb
RUN a2dissite buddycloud-apache-virtual-host; rm /etc/apache2/sites-available/buddycloud-apache-virtual-host*
ADD buddycloud.net /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf
ADD config.js /usr/share/buddycloud-webclient/config.js

#logstash stuff
RUN wget -O- http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo deb http://packages.elasticsearch.org/logstash/1.4/debian stable main >> /etc/apt/sources.list.d/logstash.list
RUN apt-get update && apt-get install -y logstash=1.4.1-1-bd507eb
ADD logstash.conf /etc/logstash/conf.d/logstash.conf
RUN service logstash restart
#RUN /opt/logstash/bin/logstash agent -f /etc/logstash/conf.d/logstash.conf -l /var/log/logstash/logstash.log &

ENTRYPOINT mkdir -p /var/run/apache2; ln -s /srv/secret/buddycloud.com.pem /etc/apache2/certs/buddycloud.com.pem;/tmp/replace-api-hosting-vars; cat /etc/apache2/apache2.conf; service apache2 restart; /opt/logstash/bin/logstash agent -f /etc/logstash/conf.d/logstash.conf -l /var/log/logstash/logstash.log &; tail -F /var/log/apache2/*.log; 
EXPOSE 80 443
