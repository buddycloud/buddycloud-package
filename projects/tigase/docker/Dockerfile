# Ubuntu/precise is the main distribution
FROM ubuntu:precise

# sanitize all package lists
RUN echo > /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list

RUN rm -rvf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl
RUN apt-get install --no-install-recommends -y software-properties-common python-software-properties
RUN add-apt-repository ppa:webupd8team/java

# add wget
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install --no-install-recommends -y wget oracle-java7-installer

# install tigase
RUN wget 'https://projects.tigase.org/attachments/download/1409/tigase-server-5.2.1-b3461-dist-max.tar.gz' -O /tmp/tigase-server.tar.gz -o /dev/null
RUN tar -xC /opt -zf /tmp/tigase-server.tar.gz
RUN mv /opt/tigase-server* /opt/tigase-server

# prepare tigase
ADD tigase.conf /opt/tigase-server/etc/tigase.conf
ADD init.properties /opt/tigase-server/etc/init.properties
ADD admin-groovy/ /opt/tigase-server/scripts/admin/
ADD UnlimitedJCEPolicy/ /usr/lib/jvm/java-7-oracle/lib/security/
ADD tigase-server.jar /opt/tigase-server/jars/tigase-server.jar

# run tigase
ENTRYPOINT cd /opt/tigase-server; java -version; tail -F logs/tigase.log.0 & ./scripts/tigase.sh run etc/tigase.conf
EXPOSE 5222 5269 5270 5290
