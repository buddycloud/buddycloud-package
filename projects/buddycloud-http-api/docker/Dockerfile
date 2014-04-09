# Ubuntu/precise is the main distribution
FROM ubuntu:precise

# sanitize all package lists
RUN echo > /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list

# add chris-lea repo
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl
RUN apt-get install --no-install-recommends -y software-properties-common python-software-properties libicu-dev
RUN add-apt-repository ppa:chris-lea/node.js

# add wget and nodejs
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs

# install the httpapi
ADD buddycloud-http-api.deb /tmp/buddycloud-http-api.deb
RUN dpkg -i /tmp/buddycloud-http-api.deb
ADD config.js /usr/share/buddycloud-http-api/config.js

ADD replace-media-server-vars /usr/share/buddycloud-http-api/replace-media-server-vars

# run the httpapi
ENTRYPOINT cd /usr/share/buddycloud-http-api; node -v; ./replace-media-server-vars; cat config.js; node node_modules/node-xmpp-client/examples/echo_bot.js test2@alps.buddycloud.net test2; node server.js
EXPOSE 9123
