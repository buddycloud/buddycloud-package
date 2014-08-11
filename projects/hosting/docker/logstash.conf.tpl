{										
 "network": {								
	"servers": ["logs.buddycloud.com:31337"],		
        "ssl certificate": "/opt/logstash-forwarder/logstash-forwarder.crt",
        "ssl key": "/opt/logstash-forwarder/logstash-forwarder.key",	
        "ssl ca": "/opt/logstash-forwarder/logstash-forwarder.crt",
        "timeout": 15						
  },							
  "files": [
    {
      "paths": [ "/var/log/hosting/hosting.log" ],
      "fields": { "type": "hosting", "env": "#DEPLOYMENT_ENV#" }
    }
  ]
}
