# Ubuntu/precise is the main distribution
FROM ubuntu:precise

# sanitize all package lists
RUN echo > /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list

# add wget
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget openjdk-7-jdk

# install tigase
RUN wget 'https://projects.tigase.org/attachments/download/1319/tigase-server-5.2.0-rc2-b3437-dist-max.tar.gz' -O /tmp/tigase-server.tar.gz -o /dev/null
RUN tar -xC /opt -zf /tmp/tigase-server.tar.gz
RUN mv /opt/tigase-server* /opt/tigase-server

# prepare tigase
ADD tigase.conf /opt/tigase-server/etc/tigase.conf
ADD init.properties /opt/tigase-server/etc/init.properties
ADD admin-groovy/ /opt/tigase-server/scripts/admin/

# run tigase
ENTRYPOINT cd /opt/tigase-server && ./scripts/tigase.sh run etc/tigase.conf
EXPOSE 5222 5269

