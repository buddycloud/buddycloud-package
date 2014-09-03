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

# install and configure the webclient
ADD webclient.deb /tmp/webclient.deb
RUN dpkg -i /tmp/webclient.deb
ADD config.js /usr/share/buddycloud-webclient/config.js

# install apache2
RUN apt-get install --no-install-recommends -y wget apache2

# enable mods
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_wstunnel
RUN a2enmod ssl
RUN a2enmod headers
RUN a2enmod expires
RUN a2enmod rewrite

# stage CAs certificates
RUN mkdir -p /etc/apache2/certs
RUN wget --no-check-certificate https://www.startssl.com/certs/sub.class1.server.ca.crt \
    -O /etc/apache2/certs/sub.class1.server.ca.crt
    
# stage apache2 config file
ADD apache2.conf /etc/apache2/apache2.conf

# remove existing hosts
RUN a2dissite buddycloud-apache-virtual-host 000-default.conf default-ssl.conf
RUN rm -f /etc/apache2/sites-available/*; rm -f /etc/apache2/sites-enabled/*

# stage buddycloud vhost
ADD buddycloud.net /etc/apache2/sites-available/buddycloud-hosting.conf

# install logstash
ADD logstash-forwarder_0.3.1_amd64.deb /tmp/logstash-forwarder_0.3.1_amd64.deb
RUN dpkg -i /tmp/logstash-forwarder_0.3.1_amd64.deb

# Add and make run.sh excecutable
ADD run_ls_fw.sh /usr/local/bin/run_ls_fw.sh
ADD log.list /tmp/log.list
RUN chmod 755 /usr/local/bin/run_ls_fw.sh

ENTRYPOINT ln -s /srv/secret/logstash-forwarder.crt /opt/logstash-forwarder/logstash-forwarder.crt; ln -s /srv/secret/logstash-forwarder.key /opt/logstash-forwarder/logstash-forwarder.key; ln -s /srv/secret/buddycloud.pem /etc/apache2/certs/buddycloud.pem; a2ensite buddycloud-hosting.conf; service apache2 restart; /bin/bash /usr/local/bin/run_ls_fw.sh; tail -F /var/log/apache2/*.log
EXPOSE 80 443
