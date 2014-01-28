Running a buddycloud stack in docker
====================================

Run Tigase (XMPP server)
------------------------

```
cd tigase
docker build -t tigase .
docker run -d --name=tigase -h=tigase.si.buddycloud.com -P -p 5222:5222 -p 5223:5223 -p 5269:5269 -p 5280:5280 -p 5290:5290 -p 5555:5555 -t tigase
```


