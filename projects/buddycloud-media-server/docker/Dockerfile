# Ubuntu/precise is the main distribution
FROM ubuntu:precise

<<<<<<< HEAD
# sanitize all package lists
RUN echo > /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list

# add wget and java
=======
# add java
>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb
RUN rm -rvf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl
RUN apt-get install --no-install-recommends -y openjdk-7-jdk dbconfig-common
RUN apt-get install --no-install-recommends -y postgresql-client
ADD buddycloud-media-server.deb /tmp/buddycloud-media-server.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/buddycloud-media-server.deb

<<<<<<< HEAD
=======
# create hosting XMPP account
ADD create-media-account.sh /tmp/create-media-account.sh
RUN bash /tmp/create-media-account.sh

>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb
# update configuration files
ADD logback.xml /usr/share/buddycloud-media-server/logback.xml
ADD mediaserver.properties /usr/share/buddycloud-media-server/mediaserver.properties

<<<<<<< HEAD
ENTRYPOINT cd /usr/share/buddycloud-media-server; java -cp .:*:lib/* com.buddycloud.mediaserver.Main
=======
ENTRYPOINT cd /usr/share/buddycloud-media-server; java -jar buddycloud-media-server-jar-with-dependencies.jar
>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb
EXPOSE 60080
