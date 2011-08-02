#!/bin/bash

INPUTFILE=$1
BASEDIR=~/hashes/crackall.git
JOHN=$BASEDIR/john-1.7.8-jumbo-4
JTR=$JOHN/run/john
DICTS=/data/dicts
POTS=$BASEDIR/pots

SUBTYPES=$( $JTR $BASEDIR/passwords/paste52.txt --format=gen_md5 --subformat=list | cut -d' ' -f3 | cut -b9- | tr -d \) )

#echo $SUBTYPES

for st in $SUBTYPES
do
	echo "*** WORKING on subtype" $st
	$JTR $INPUTFILE --format=md5-gen "--subformat=md5_gen($st)" \
		--wordlist=$DICTS/Quick_Lists/rockyou.txt --mem-file-size=500 
		--pot=$POTS/whatsinit_$(basename ${INPUTFILE})_${st}

	### this doesnt work because jtr doesnt take multi-dictionary inputs (but hashcat does, hint hint)
	#$JTR $INPUTFILE --format=md5-gen "--subformat=md5_gen($st)" --wordlist=$DICTS/Really_Quick/* --mem-file-size=500
done
