# Ubuntu/precise is the main distribution
FROM ubuntu:precise

# sanitize all package lists
RUN echo > /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list

# add wget and java
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget openjdk-7-jdk dbconfig-common

# install the java-server
RUN wget 'http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-server-java/buddycloud-server-java-0.1+dev20140126.git.d6294ab/buddycloud-server-java_0.1+dev20140126.git.d6294ab-1_all.deb' -O /tmp/buddycloud-server-java.deb -o /dev/null
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/buddycloud-server-java.deb

# run java-server
ENTRYPOINT cd /usr/share/buddycloud-server-java; /usr/bin/java -jar channel-server-with-dependencies.jar
# EXPOSE 5222:5222 5223:5223 5269:5269 5280:5280 5290:5290 5555:5555

