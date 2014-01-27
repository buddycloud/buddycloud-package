 Ubuntu/precise is the main distribution
FROM ubuntu:precise

# sanitize all package lists
RUN echo > /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list

# add python
RUN apt-get update
RUN apt-get install --no-install-recommends -y python-setuptools python-dev postgresql-server-dev-9.1 libsqlite3-dev python dbconfig-common build-essential

ADD buddycloud-hosting.deb /tmp/buddycloud-hosting.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/buddycloud-hosting.deb
ADD buddycloud-hosting.conf /etc/dbconfig-common/buddycloud-hosting.conf

ENTRYPOINT cd /usr/share/buddycloud-hosting; python run.py
EXPOSE 3000
