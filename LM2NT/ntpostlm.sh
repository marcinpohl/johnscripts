#!/bin/bash
set -x
set +e
shopt -u dotglob         
shopt -s extglob         
shopt -u failglob       
shopt -u globstar      
shopt -u nocaseglob   
shopt -u nullglob    

JTRBASE="/home/marcin/hashes/crackall.git"
JTR="${JTRBASE}/john-1.7.7-jumbo-5/run/john"
JTRconfigLM="${JTRBASE}/john.conf"
JTRconfigNT="${JTRBASE}/john-ntpostlm.conf"
PASSWD="${JTRBASE}/crackme"
OUTPUTDIR="${JTRBASE}/johnscripts/LM2NT"

#DEBUG=0  #0 slow, 1 fast
DESTRUCT=1  #0 destructive, 1 leaves the old files alone

#pushd $(pwd)
#cd ${OUTPUTDIR}

function phase1reallyquick {
    echo "*** Starting to do the really quick dictionaries"
	   DICTS1="${JTRBASE}/dicts/Really_Quick/*"
	   for d in $DICTS1; do
		  $JTR \
			 --config=${JTRconfigLM} \
			 --session=LM_phase1 \
			 --pot=LM_phase1.pot \
			 --w:"$d" --rules \
			 --format=lm \
			 $PASSWD
			 done
}

function phase1quicklists {
### BIGGER DICTIONARIES, still should be fast, debug only
echo "*** Starting to do the Quick Lists"
   DICTS2=${JTRBASE}/dicts/Quick_Lists/*
   for d in $DICTS2; do
	    $JTR \
		  --config=${JTRconfigLM} \
		  --session=LM_phase1 \
		  --pot=LM_phase1 \
		  --w:"$d" \
		  --format=lm \
		  $PASSWD
    done
}

function phase1largelists {
echo "*** Starting to do the Large Lists"
#DICTS2=$(ls -1 dicts/Large_Lists/*)
#DICTS3=$(find $JTRBASE/dicts/Large_Lists/ -type f -maxdepth 1)
DICTS3="$JTRBASE/dicts/Large_Lists/*"
for d in $DICTS3; do
	if [ -f $d ] ; 
	then
	    $JTR \
		    --config=${JTRconfigLM} \
		    --session=LM_phase1 \
		    --pot=LM_phase1 \
		    --wordlist="$d" \
		    --format=lm \
		    $PASSWD
	fi
done
}

function phase1bruteforce {
### FOR BRUTEFORCING THE REST
echo "*** Starting to do BRUTE FORCE"
echo "*** Hit CTRL-C after 20mins or whenever the passwords stop spewing"
$JTR \
   --config=$JTRconfigLM \
   --session=LM_phase1bruteforce \
   --pot=LM_phase1 \
   --format=lm \
   $PASSWD
}

function phase1incremental {
echo "*** Starting to do INCREMENTAL-ROCKYOULANMAN "
$JTR \
	--incremental=RockYouLanMan \
	--session=LM_phase1incremental \
	--pot=LM_phase1.pot \
	--format=lm \
	$PASSWD
}

function phase1single {
echo "*** Starting to do INCREMENTAL-ROCKYOULANMAN "
$JTR \
	--session=LM_phase1single \
	--pot=LM_phase1.pot \
	--format=lm \
	$PASSWD
}

function phase2 {
### extraction of cracked LM
echo "*** Extracting the cracked LM hashes"
$JTR -format=lm -show -pot=./LM_phase1.pot $PASSWD | \
	grep -v "password hashes cracked" | \
	sort -u | \
	cut -d: -f2 > ./LMcracked
}

function phase3 {
### using the cracked LM list as wordlist, with different rules
echo "*** Starting to crack NT only for passwords with cracked LM"
$JTR \
--config=${JTRconfigNT} \
--session=./NT_phase3 \
--pot=./LM_phase1.pot \
--w=./LMcracked --rules \
--format=nt \
$PASSWD

# output some stats
echo -n "LanMan stats: "
$JTR -show --pot=./LM_phase1.pot --format=lm $PASSWD | tail -n1
echo -n "NTLM stats: "
$JTR -show --pot=./LM_phase1.pot --format=nt $PASSWD | tail -n1
}

### script actually starts to run here
if [ $DESTRUCT -eq 0 ]
then
if [ -f LM_phase1 ]; then rm LM_phase1* ; fi
#if [ -f LM_phase1 ]; then rm NT_phase3* ; fi
if [ -f LM_phase1 ]; then rm LMcracked ; fi
fi

#phase1reallyquick
#phase1quicklists
#phase1largelists
#phase1bruteforce
#phase1incremental
#phase1single
phase2
phase3

