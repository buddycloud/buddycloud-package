PGPASSWORD=xohfeeko psql -U integration_tigase -d integration_tigase -h db01.buddycloud.com -p 5432 -c "SELECT TigAddUserPlainPw('hosting-admin@buddycloud.net', 'rEXUudV7');" | true
