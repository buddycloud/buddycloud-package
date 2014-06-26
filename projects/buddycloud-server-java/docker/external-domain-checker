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
cur.execute('SELECT COUNT(*) FROM vhost WHERE "name"=%s', (sys.argv[1],))
result = cur.fetchone()
if result[0] == 0:
    raise Exception()
