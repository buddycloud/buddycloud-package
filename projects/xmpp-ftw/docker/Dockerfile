# Ubuntu/precise is the main distribution
FROM ubuntu:precise

# sanitize all package lists
RUN echo > /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list

# add chris-lea repo
RUN rm -rvf /var/lib/apt/lists/*
RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl
RUN apt-get install --no-install-recommends -y software-properties-common python-software-properties build-essential libicu-dev
RUN add-apt-repository ppa:chris-lea/node.js

# add wget and nodejs
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs

# install the xmpp-ftw
RUN mkdir -p /usr/share/xmpp-ftw/public/scripts
ADD index.js /usr/share/xmpp-ftw/index.js
ADD package.json /usr/share/xmpp-ftw/package.json
RUN cd /usr/share/xmpp-ftw; npm install

# run the endpoint
ENTRYPOINT cd /usr/share/xmpp-ftw; node -v; npm start
EXPOSE 6000
