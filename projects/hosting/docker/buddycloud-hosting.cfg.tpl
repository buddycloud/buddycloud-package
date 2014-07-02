[database]
url=postgres://#HOSTING_JDBC_DB_USER#:#HOSTING_JDBC_DB_PASS#@#JDBC_DB_URL#/#HOSTING_JDBC_DB_NAME#

[xmpp]
jid=#HOSTING_ADMIN_XMPP_CLIENT#
host=#XMPP_CLIENT_HOST#
port=#XMPP_CLIENT_PORT#
password=#HOSTING_ADMIN_XMPP_PASS#
vhostman=vhost-man@buddycloud.net
sessman=sess-man@buddycloud.net

[buddycloud]
account=http://#BC_ENV_HOST#:9123/account

[flask]
secret=v3ry53cr3t
baseurl=#HOSTING_BASE_URL#

[dns]
basedomain=#HOSTING_BASE_DOMAIN#
tsigkeyname=#HOSTING_DNS_KEY_NAME#
tsigkeysecret=#HOSTING_DNS_KEY_SECRET#
arecord=#HOSTING_A_RECORD#
csrecord=#CHANNELS_XMPP_COMPONENT_SUBDOMAIN#
bindhost=#HOSTING_DNS_HOST#

[smtp]
host=#HOSTING_SMTP_HOST#
sender=#HOSTING_SMTP_SENDER#
