SSLStrictSNIVHostCheck on

<VirtualHost *:80>
        ServerAlias buddycloud.*
        RewriteEngine On
        RewriteCond %{HTTP_HOST} ^buddycloud\.(.*)$
        RewriteRule ^(.*)$ https://http.#BC_DOMAIN#/?h=%1
</VirtualHost>

<VirtualHost *:80>
        # push any non-secure requests to HTTPS
        ServerName  hosting.#BC_DOMAIN#
        RewriteEngine On
        RewriteCond %{HTTPS} off
        RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}
</VirtualHost>

<VirtualHost *:443>
        ServerName hosting.#BC_DOMAIN#
        KeepAlive On
        ProxyPass / http://#BC_ENV_HOST#:3000/
        ProxyPassReverse / http://#BC_ENV_HOST#:3000/
        SSLEngine On
        SSLCertificateFile      /etc/apache2/certs/buddycloud.pem
        SSLCertificateKeyFile   /etc/apache2/certs/buddycloud.pem
        SSLCertificateChainFile /etc/apache2/certs/buddycloud.pem
        SSLCACertificateFile    /etc/apache2/certs/buddycloud.pem
        
        LogLevel alert
        ErrorLog  /var/log/apache2/hosting.buddycloud.com-error.log
        CustomLog /var/log/apache2/hosting.buddycloud.com-access.log combined
</VirtualHost>

<VirtualHost *:80>
        # push any non-secure requests to HTTPS
        ServerName  web-hosting.#BC_DOMAIN#
        ServerAlias *.#BC_DOMAIN#
        RewriteEngine On
        RewriteCond %{HTTPS} off
        RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}
</VirtualHost>

<VirtualHost *:443>
        ServerName  web-hosting.#BC_DOMAIN#
        ServerAlias *.#BC_DOMAIN#
        SSLEngine On
        SSLCertificateFile      /etc/apache2/certs/buddycloud.pem
        SSLCertificateKeyFile   /etc/apache2/certs/buddycloud.pem
        SSLCertificateChainFile /etc/apache2/certs/buddycloud.pem
        SSLCACertificateFile    /etc/apache2/certs/buddycloud.pem
        DocumentRoot /usr/share/buddycloud-webclient/
        LogLevel alert
        ErrorLog  /var/log/apache2/web.buddycloud.com-error.log
        CustomLog /var/log/apache2/web.buddycloud.com-access.log combined
        RewriteEngine On
        RewriteCond %{REQUEST_URI} !^/js/
        RewriteCond %{REQUEST_URI} !^/img/
        RewriteCond %{REQUEST_URI} !^/css/
        RewriteCond %{REQUEST_URI} !^/timestamp
        RewriteCond %{REQUEST_URI} !^/prototypes/
        RewriteCond %{REQUEST_URI} !^/locales/
        RewriteCond %{REQUEST_URI} !^/config\.js$
        RewriteCond %{REQUEST_URI} !^/manifest\.webapp$
        RewriteCond %{REQUEST_URI} !^/api/
        RewriteCond %{REQUEST_URI} !^/xmpp-ftw/
        RewriteCond %{REQUEST_URI} !^/ws-xmpp
        RewriteCond %{REQUEST_URI} !^(.*)\.html$
        RewriteCond %{REQUEST_URI} !^/favicon.ico$
        RewriteRule ^(.*)$ /index.html
        #<IfModule mod_header.c>
                SetEnvIf Origin "http(s)?://(.+)" AccessControlAllowOrigin=$0
                Header set Access-Control-Allow-Origin %{AccessControlAllowOrigin}e env=AccessControlAllowOrigin
        #</IfModule>
        # Speed up the website
        FileETag                             None
        ExpiresActive On
        ExpiresDefault                       "access plus 1 seconds"
        ExpiresByType text/html              "access plus 1 hours"
        ExpiresByType image/jpeg             "access plus 1 hours"
        ExpiresByType image/png              "access plus 1 hours"
        ExpiresByType text/css               "access plus 1 hours"
        ExpiresByType application/javascript "access plus 1 hours"
        # For Firefox OS Manifest file serving
        AddType application/x-web-app-manifest+json .webapp

        KeepAlive On
        ProxyPass /api/ http://#BC_ENV_HOST#:9123/
        ProxyPassReverse /api/ http://#BC_ENV_HOST#:9123/
        
        ProxyPass /xmpp-ftw/primus/1/websocket ws://#BC_ENV_HOST#:6000/primus/1/websocket
	ProxyPassReverse /xmpp-ftw/primus/1/websocket ws://#BC_ENV_HOST#:6000/primus/1/websocket

	ProxyPass /ws-xmpp ws://#BC_ENV_HOST#:5290/
        ProxyPassReverse /ws-xmpp ws://#BC_ENV_HOST#:5290/

	ProxyPass /xmpp-ftw/ http://#BC_ENV_HOST#:6000/
	ProxyPassReverse /xmpp-ftw/ http://#BC_ENV_HOST#:6000/
        
</VirtualHost>
