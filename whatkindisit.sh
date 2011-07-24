#!/bin/bash

JOHN=~/hashes/crackall.git/john-1.7.8-jumbo-4
JTR=$JOHN/run/john
SUBTYPES=$( $JTR passwords/paste52.txt --format=gen_md5 --subformat=list | cut -d' ' -f3 | cut -b9- | tr -d \) )

echo $SUBTYPES

for st in $SUBTYPES
do
	$JTR passwords/paste52.txt --format=md5-gen "--subformat=md5_gen($st)" --wordlist=$DICTS/Quick_Lists/rockyou.txt --mem-file-size=500
done
