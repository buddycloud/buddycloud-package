#!/usr/bin/python
 
from passlib.hash import scram
import hmac
import sha
import sys

plain_password = sys.argv[1]
salt = sys.argv[2]
iteration_count = int(sys.argv[3])
expected_stored_key = sys.argv[4]
expected_server_key = sys.argv[5]

encrypted_password = scram.encrypt(plain_password, rounds=iteration_count, 
                                   salt=salt, algs="sha1")
digest_bytes = scram.extract_digest_info(encrypted_password, "sha1")[2]
stored_key = sha.new(hmac.new(digest_bytes, 
                              "Client Key", sha).digest()).hexdigest()
server_key = hmac.new(digest_bytes, "Server Key", sha).hexdigest()

print server_key == expected_server_key and stored_key == expected_stored_key
