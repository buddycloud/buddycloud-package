# Ubuntu/precise is the main distribution
FROM ubuntu:precise

# sanitize all package lists
RUN echo > /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list

# add wget and java
RUN apt-get update
RUN apt-get install --no-install-recommends -y openjdk-7-jdk dbconfig-common

# install the java-server
ADD buddycloud-server-java /tmp/buddycloud-server-java.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/buddycloud-server-java.deb

ADD buddycloud-server-java.conf /etc/dbconfig-common/buddycloud-server-java.conf
ADD configuration.properties /usr/share/buddycloud-server-java/configuration.properties
# run java-server
ENTRYPOINT cd /usr/share/buddycloud-server-java; /usr/bin/java -jar channel-server-with-dependencies.jar
