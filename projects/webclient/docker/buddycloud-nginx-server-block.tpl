server {
    listen 80;
    server_name hosting.#BC_DOMAIN#;
    rewrite ^ https://$server_name$request_uri? permanent;
}

server {
    listen              443 ssl;
    server_name         hosting.#BC_DOMAIN#;
    ssl_certificate     /etc/certs/buddycloud.pem;
    ssl_certificate_key /etc/certs/buddycloud.pem;
    ssl_protocols       SSLv3 TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://#BC_ENV_HOST#:3000/;
    }
}

server {
    listen 80;
    server_name *.#BC_DOMAIN# ~^buddycloud\.(?<domain>.+)$;
    return 301 https://$host$request_uri;
}

map $host $forwarded_host {
    ~^buddycloud\.(?<domain>.+)$ $domain;
    default $host;
}

server {
    listen              443 ssl;
    server_name         *.#BC_DOMAIN# ~^buddycloud\.(?<domain>.+)$;
    ssl_certificate     /etc/certs/buddycloud.pem;
    ssl_certificate_key /etc/certs/buddycloud.pem;
    ssl_protocols       SSLv3 TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;

    root /usr/share/buddycloud-webclient/;
    index index.html;

    location /api/ {
        proxy_pass http://#BC_ENV_HOST#:9123/;
        proxy_set_header X-Forwarded-Host $forwarded_host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; 
    }

    location /primus/1/websocket {
        proxy_pass http://#BC_ENV_HOST#:6000/primus/1/websocket;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location /ws-xmpp {
        proxy_pass http://#BC_ENV_HOST#:5290/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location /primus/ {
        proxy_pass http://#BC_ENV_HOST#:6000/primus/;
    }

    location /scripts/primus {
        proxy_pass http://#BC_ENV_HOST#:6000/scripts/primus/;
    }
}
