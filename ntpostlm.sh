#!/bin/bash
set -x
set +e
shopt -u dotglob         
shopt -s extglob         
shopt -u failglob       
shopt -u globstar      
shopt -u nocaseglob   
shopt -u nullglob    

JTRBASE="~/hashes/crackall.git"
JTR="${JTRBASE}/john-1.7.7-jumbo-5/run/john"
JTRconfigLM="${JTRBASE}/john.conf"
JTRconfigNT="${JTRBASE}/john-ntpostlm.conf"
PASSWD="${JTRBASE}/crackme"
OUTPUTDIR="${JTRBASE}/LM2NT"

DEBUG=1  #0 slow, 1 fast
DESTRUCT=1  #0 destructive, 1 leaves the old files alone

pushd $(pwd)
cd ${JTRBASE}

if [ $DESTRUCT -eq 0 ]
then
    if [ -f LM_phase1 ]; then rm LM_phase1* ; fi
    if [ -f LM_phase1 ]; then rm LNT_phase1* ; fi
    if [ -f LM_phase1 ]; then rm LMcracked ; fi
fi

echo "*** Starting to do the really quick dictionaries"
DICTS1="${JTRBASE}/dicts/Really_Quick/*"
for d in $DICTS1; do
	$JTR \
		--config=${JTRconfigLM} \
		--session=LM_phase1 \
		--pot=LM_phase1 \
		--w:"$d" --rules \
		--format=lm \
		$PASSWD
done

### BIGGER DICTIONARIES, still should be fast, debug only
if [ $DEBUG -eq 0 ] 
then
#	echo "*** Starting to do the Quick Lists"
#    DICTS2=$(ls -1 dicts/Quick_Lists/*)
#    for d in $DICTS2; do
#	    $JTR \
#		  --config=${JTRconfigLM} \
#		  --session=LM_phase1 \
#		  --pot=LM_phase1 \
#		  --w:"$d" \
#		  --format=lm \
#		  $PASSWD
#    done
	echo "*** Starting to do the Large Lists"
    #DICTS2=$(ls -1 dicts/Large_Lists/*)
    DICTS2=$(find dicts/Large_Lists/ -type f -maxdepth 1)
    for d in $DICTS2; do
	    $JTR \
		  --config=${JTRconfigLM} \
		  --session=LM_phase1 \
		  --pot=LM_phase1 \
		  --w:"$d" \
		  --format=lm \
		  $PASSWD
    done

### FOR BRUTEFORCING THE REST
#	echo "*** Starting to do BRUTE FORCE"
#    echo "*** Hit CTRL-C after 20mins or whenever the passwords stop spewing"
#    $JTR \
#	   --config=$JTRconfigLM \
#	   --session=LM_phase1 \
#	   --pot=LM_phase1 \
#	   --format=LM \
#	   $PASSWD
	echo "*** Starting to do INCREMENTAL-ROCKYOULANMAN "
    $JTR \
	   --incremental=RockYouLanMan \
	   --session=LM_phase1 \
	   --pot=LM_phase1 \
	   --format=LM \
	   $PASSWD
fi	#  end of if DEBUG
exit 0
### extraction of cracked LM
echo "*** Extracting the cracked LM hashes"
$JTR -format=lm -show -pot=LM_phase1 $PASSWD | \
	grep -v "password hashes cracked" | \
	sort -u | \
	cut -d: -f2 > LMcracked

### using the cracked LM list as wordlist, with different rules
$JTR \
	--config=${JTRconfigNT} \
	--session=NT_phase1 \
	--pot=NT_phase1 \
	--w:LMcracked --rules \
	--format=nt \
	$PASSWD

# output some stats
echo -n "LanMan stats: "
$JTR -show -format=lm $PASSWD | tail -n1
echo -n "NTLM stats: "
$JTR -show -format=nt $PASSWD | tail -n1

#return to whatever was before
popd
