#!/bin/bash

cat << EOF > /tmp/config.json
{
 "network": {
	"servers": ["abyss.buddycloud.com:31337"],
        "ssl certificate": "/opt/logstash-forwarder/logstash-forwarder.crt",
        "ssl key": "/opt/logstash-forwarder/logstash-forwarder.key",
        "ssl ca": "/opt/logstash-forwarder/logstash-forwarder.crt",
        "timeout": 15
  },
  "files": [
    {
      "paths": [ "/var/log/apache2/web.buddycloud.com-access.log" ],
      "fields": { "type": "web_apache_access" }
    },
    {
      "paths": [ "/var/log/apache2/other_vhosts_access.log" ],
      "fields": { "type": "other_vhosts_apache_access" }
    },
    {
      "paths": [ "/var/log/apache2/hosting.buddycloud.com-access.log" ],
      "fields": { "type": "hosting_apache_access" }
    },
    {
      "paths": [ "/var/log/apache2/xmpp-ftw.buddycloud.com-access.log" ],
      "fields": { "type": "xmpp-ftw_apache_access" }
    },
    {
      "paths": [ "/var/log/apache2/error.log" ],
      "fields": { "type": "general_apache_error" }
    }
  ]
}
EOF

/opt/logstash-forwarder/bin/logstash-forwarder -config /tmp/config.json &



