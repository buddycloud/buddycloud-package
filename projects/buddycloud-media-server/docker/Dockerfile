# Ubuntu/precise is the main distribution
FROM ubuntu:precise

# add java
RUN rm -rvf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl
RUN apt-get install --no-install-recommends -y openjdk-7-jdk dbconfig-common
RUN apt-get install --no-install-recommends -y postgresql-client
ADD buddycloud-media-server.deb /tmp/buddycloud-media-server.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/buddycloud-media-server.deb

# add logstash sources list and install it
RUN apt-get install --no-install-recommends -y wget
RUN wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' | tee /etc/apt/sources.list.d/logstash.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y logstash-forwarder

# add logstash conf
ADD logstash.conf /tmp/logstash.conf

# create hosting XMPP account
ADD create-media-account.sh /tmp/create-media-account.sh
RUN bash /tmp/create-media-account.sh

# update configuration files
ADD logback.xml /usr/share/buddycloud-media-server/logback.xml
ADD mediaserver.properties /usr/share/buddycloud-media-server/mediaserver.properties

ENTRYPOINT ln -s /srv/secret/logstash-forwarder.crt /opt/logstash-forwarder/logstash-forwarder.crt; ln -s /srv/secret/logstash-forwarder.key /opt/logstash-forwarder/logstash-forwarder.key; /opt/logstash-forwarder/bin/logstash-forwarder -config /tmp/logstash.conf & cd /usr/share/buddycloud-media-server; java -jar buddycloud-media-server-jar-with-dependencies.jar
EXPOSE 60080
