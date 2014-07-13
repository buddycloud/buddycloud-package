#!/bin/bash

OUTPUT=/tmp/config.json
config=( $(<log.list) )
i=0



#generate cofiguration with file list based on log.list. but keeping one file fix to not corrupt the config
echo -en '
{										
 "network": {								
	"servers": ["abyss.buddycloud.com:31337"],		
        "ssl certificate": "/opt/logstash-forwarder/logstash-forwarder.crt",
        "ssl key": "/opt/logstash-forwarder/logstash-forwarder.key",	
        "ssl ca": "/opt/logstash-forwarder/logstash-forwarder.crt",
        "timeout": 15						
  },							
  "files": [' > $OUTPUT

while [ $((i+1)) -lt ${#config[@]} ]; do

  echo -en '\n\t{
	"paths": [ "'"${config[i]}"'" ],
	"fields": { "type": "'"${config[$((i+1))]}"'" }
	},' >> $OUTPUT
  i=$((i+2))
done
echo -en '
    {
      "paths": [ "/var/log/apache2/error.log" ],
      "fields": { "type": "general_apache_error" }
    }
  ]
}' >> $OUTPUT


/opt/logstash-forwarder/bin/logstash-forwarder -config /tmp/config.json &



