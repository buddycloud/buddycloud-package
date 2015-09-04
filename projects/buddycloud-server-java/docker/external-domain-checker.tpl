#!/usr/bin/python

import psycopg2
import sys
import os
import urlparse

db_url = 'postgres://#HOSTING_JDBC_DB_USER#:#HOSTING_JDBC_DB_PASS#@#JDBC_DB_URL#/#HOSTING_JDBC_DB_NAME#'
parsed_url = urlparse.urlparse(db_url)

username = parsed_url.username
password = parsed_url.password
database = parsed_url.path[1:]
hostname = parsed_url.hostname

conn = psycopg2.connect(
    database = database,
    user = username,
    password = password,
    host = hostname
)

cur = conn.cursor()
<<<<<<< HEAD
cur.execute('SELECT COUNT(*) FROM vhost WHERE "name"=%s', (sys.argv[1],))
result = cur.fetchone()
if result[0] == 0:
    raise Exception()
=======
cur.execute('SELECT name FROM vhost')
rows = cur.fetchall()
print ",".join([str(row[0]) for row in rows])
>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb
