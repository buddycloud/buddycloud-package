xmpp.host=#XMPP_COMPONENT_HOST#
xmpp.port=#XMPP_COMPONENT_PORT#
xmpp.secretkey=#CHANNELS_XMPP_COMPONENT_PASSWORD#

server.domain.checker=/usr/bin/external-domain-checker
server.domain.channels=#CHANNELS_XMPP_COMPONENT_SUBDOMAIN#

jdbc.proxool.alias=channelserver
jdbc.proxool.driver-url=jdbc:postgresql://#JDBC_DB_URL#/#CHANNELS_JDBC_DB_NAME#
jdbc.proxool.driver-class=#JDBC_DRIVER_CLASS#
jdbc.user=#CHANNELS_JDBC_DB_USER#
jdbc.password=#CHANNELS_JDBC_DB_PASS#
jdbc.proxool.maximum-connection-count=10
jdbc.proxool.house-keeping-test-sql=select CURRENT_DATE

# Admin users are sent all notiifcations as well as having access 
# to all posts from the /firehose node (not just from open channels)
# users.admin = user1@example.com;crawler@searchengine.org
user.admin = admin@buddycloud.net

# A list of channels (local or remote) to which to subscribe new users
# Note that the channels will not be created - they must already exist
channels.autosubscribe=lounge@topics.si.buddycloud.com

# If any of the 'channels.autosubscribe' channels are private local channels,
# then whether to automatically approve the user.
# NOTE: This will only work on local private channels
channels.autosubscribe.autoapprove=false

# Channel configuration related to access model and affiliation

channel.configuration.default.accessmodel=open
channel.configuration.default.affiliation=member

# Overrides for default configuration
channel.configuration.posts.affiliation=publisher

channel.configuration.geo.next.accessmodel=authorize
channel.configuration.geo.current.accessmodel=authorize
channel.configuration.geo.previous.accessmodel=authorize

channel.configuration.status.description=%jid%'s status
channel.configuration.status.description=The current status of %jid%
