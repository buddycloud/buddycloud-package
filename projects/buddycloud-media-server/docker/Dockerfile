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

# create hosting XMPP account
ADD create-media-account.sh /tmp/create-media-account.sh
RUN bash /tmp/create-media-account.sh

# update configuration files
ADD logback.xml /usr/share/buddycloud-media-server/logback.xml
ADD mediaserver.properties /usr/share/buddycloud-media-server/mediaserver.properties

ENTRYPOINT cd /usr/share/buddycloud-media-server; java -jar buddycloud-media-server-jar-with-dependencies.jar
EXPOSE 60080
