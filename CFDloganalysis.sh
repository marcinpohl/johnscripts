#!/bin/sh

ARG1=$1
GAWK='/bin/gawk'
PID=$$

$GAWK -F" " ' $3 ~ /^Cracked/ { print $1 } ' $ARG1 > CDFhumantime$PID.txt

$GAWK 'BEGIN 	{ FS=":" ; OFS="\t" }  \
			{ print $1,$2,$3,$4;   print 24*60*60*$1+60*60*$2+60*$3+$4 } \
	  END 	{ print NR, "Records Processed"; }' CDFhumantime$PID.txt  
#> CDFcomputertime$PID.txt
