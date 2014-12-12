# Ubuntu/precise is the main distribution
FROM ubuntu:precise

# add python
RUN rm -rvf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl
RUN apt-get install --no-install-recommends -y python-setuptools python-dev postgresql-server-dev-9.1 libsqlite3-dev python dbconfig-common build-essential
RUN apt-get install --no-install-recommends -y postgresql-client

# add logstash sources list and install it
RUN apt-get install --no-install-recommends -y wget
RUN wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' | tee /etc/apt/sources.list.d/logstash.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y logstash-forwarder

# add logstash conf
ADD logstash.conf /tmp/logstash.conf

# create hosting XMPP account
ADD create-hosting-account.sh /tmp/create-hosting-account.sh
RUN bash /tmp/create-hosting-account.sh

# install the hosting package
ADD hosting.deb /tmp/hosting.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/hosting.deb
ADD buddycloud-hosting.cfg /usr/share/buddycloud-hosting/hosting.cfg
ADD logging.cfg /usr/share/buddycloud-hosting/logging.cfg

ENTRYPOINT ln -s /srv/secret/logstash-forwarder.crt /opt/logstash-forwarder/logstash-forwarder.crt; ln -s /srv/secret/logstash-forwarder.key /opt/logstash-forwarder/logstash-forwarder.key; /opt/logstash-forwarder/bin/logstash-forwarder -config /tmp/logstash.conf & cd /usr/share/buddycloud-hosting; python run.py
EXPOSE 3000
