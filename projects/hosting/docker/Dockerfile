 Ubuntu/precise is the main distribution
FROM ubuntu:precise

# sanitize all package lists
RUN echo > /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list

# add python
RUN rm -rvf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl
RUN apt-get install --no-install-recommends -y python-setuptools python-dev postgresql-server-dev-9.1 libsqlite3-dev python dbconfig-common build-essential
RUN apt-get install --no-install-recommends -y python-sqlalchemy

ADD hosting.deb /tmp/hosting.deb
RUN /bin/echo v1
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/hosting.deb
ADD buddycloud-hosting.cfg /usr/share/buddycloud-hosting/hosting.cfg

ENTRYPOINT cd /usr/share/buddycloud-hosting; env; python run.py > /var/log/hosting/hosting.log 2>&1
EXPOSE 3000
