#!/bin/sh
openssl enc -aes-128-cbc -d -in file.encrypted -nosalt -nopad -K 31323334353637383132333435363738 -iv 31323334353637383132333435363738
exit 0
