# Ubuntu/precise is the main distribution
FROM ubuntu:trusty

# update ssl
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl

# install and configure the webclient
ADD webclient.deb /tmp/webclient.deb
RUN dpkg -i /tmp/webclient.deb
ADD config.js /usr/share/buddycloud-webclient/config.js

# install nginx
RUN apt-get install --no-install-recommends -y nginx
RUN rm /etc/nginx/sites-enabled/default

# create certs dir
RUN mkdir -p /etc/certs

# enable server block
ADD buddycloud-nginx-server-block /etc/nginx/sites-available/buddycloud.conf
RUN ln -s /etc/nginx/sites-available/buddycloud.conf /etc/nginx/sites-enabled/
ADD nginx.conf /etc/nginx/nginx.conf

# install logstash
ADD logstash-forwarder_0.3.1_amd64.deb /tmp/logstash-forwarder_0.3.1_amd64.deb
RUN dpkg -i /tmp/logstash-forwarder_0.3.1_amd64.deb

# Add and make run.sh excecutable
ADD run_ls_fw.sh /usr/local/bin/run_ls_fw.sh
ADD log.list /tmp/log.list
RUN chmod 755 /usr/local/bin/run_ls_fw.sh

ENTRYPOINT ln -s /srv/secret/logstash-forwarder.crt /opt/logstash-forwarder/logstash-forwarder.crt; ln -s /srv/secret/logstash-forwarder.key /opt/logstash-forwarder/logstash-forwarder.key; ln -s /srv/secret/buddycloud.pem /etc/certs/buddycloud.pem; /bin/bash /usr/local/bin/run_ls_fw.sh; /usr/sbin/nginx -c /etc/nginx/nginx.conf
EXPOSE 80 443
