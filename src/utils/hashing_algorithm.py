#!/bin/env/python
import hashlib
import binascii


def encode_rabbit_password_hash(salt, password):
    salt_and_password = salt + password.encode('utf-8').hex()
    salt_and_password = bytearray.fromhex(salt_and_password)
    salted_sha256 = hashlib.sha256(salt_and_password).hexdigest()
    password_hash = bytearray.fromhex(salt + salted_sha256)
    password_hash = binascii.b2a_base64(password_hash).strip().decode('utf-8')
    return password_hash

def decode_rabbit_password_hash(password_hash):
    password_hash = binascii.a2b_base64(password_hash)
    decoded_hash = bytes.fromhex(password_hash).decode('utf-8')
    return decoded_hash[0:8], decoded_hash[8:]

def check_rabbit_password(test_password, password_hash):
    salt, hash_md5sum = decode_rabbit_password_hash(password_hash)
    test_password_hash = encode_rabbit_password_hash(salt, test_password)
    return test_password_hash ==  password_hash




