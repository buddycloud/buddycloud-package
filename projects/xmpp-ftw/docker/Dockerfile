# Ubuntu/precise is the main distribution
FROM ubuntu:precise

ENV http_proxy http://172.17.42.1:3128

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
ADD package.json /usr/share/xmpp-ftw/package.json
RUN cd /usr/share/xmpp-ftw; npm config set registry http://registry.npmjs.org/; npm install
ADD index.js /usr/share/xmpp-ftw/index.js
RUN mkdir -p /usr/share/xmpp-ftw/public/scripts/primus

ENV http_proxy ""

# run the endpoint
ENTRYPOINT cd /usr/share/xmpp-ftw; node -v; npm start >> /var/log/xmpp-ftw/xmpp-ftw.log
EXPOSE 6000
