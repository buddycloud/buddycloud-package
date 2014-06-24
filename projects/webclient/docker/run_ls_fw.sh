#!/bin/bash

cat << EOF > /tmp/config.json
{
 "network": {
	"servers": ["abyss.budycloud.com:31337"],
        "ssl certificate": "/opt/logstash-forwarder/logstash-forwarder.crt",
        "ssl key": "/opt/logstash-forwarder/logstash-forwarder.key",
        "ssl ca": "/opt/logstash-forwarder/logstash-forwarder.crt",
        "timeout": 15
  },
  "files": [
    {
      "paths": [ "/var/log/apache2/web.buddycloud.com-access.log" ],
      "fields": { "type": "web-buddycloud-access" }
    }
  ]
}
EOF

/opt/logstash-forwarder/bin/logstash-forwarder -config /tmp/config.json &




#OLD LOGSTASH CONFIG
#input{
#	file { 
#	 type => "general_apache_error"
#	 path => "/var/log/apache2/error.log"
#	}
#	file {
#	 type => "xmpp-ftw_apache_error"
#	 path => "/var/log/apache2/xmpp-ftw.buddycloud.com-error.log"
#	}
#	file {
#         type => "web_apache_error"
#         path => "/var/log/apache2/web.buddycloud.com-error.log"
#        }
#	file {
#         type => "hosting_apache_error"
#         path => "/var/log/apache2/hosting.buddycloud.com-error.log"
#        }
#	file {
#         type => "web_apache_access"
#         path => "/var/log/apache2/web.buddycloud.com-access.log"
#        }
#	file {
#         type => "other_vhosts_apache_access"
#         path => "/var/log/apache2/other_vhosts_access.log"
#        }
#	file {
#         type => "hosting_apache_access"
#         path => "/var/log/apache2/hosting.buddycloud.com-access.log"
#        }
#	file {
#         type => "xmpp-ftw_apache_access"
#         path => "/var/log/apache2/xmpp-ftw.buddycloud.com-access.log"
#        }
#}
#output{
#	udp {
#		host => "abyss.buddycloud.com"
#		port => 31337
#	}
#}
