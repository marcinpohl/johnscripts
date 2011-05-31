#!/bin/bash
set -x
set -e
shopt -u dotglob         
shopt -s extglob         
shopt -u failglob       
shopt -u globstar      
shopt -u nocaseglob   
shopt -u nullglob    

JTR=~/hashes/crackall.git/jtr/john
JTRconfigLM=~/hashes/crackall.git/jtr/john.conf
JTRconfigNT=~/hashes/crackall.git/jtr/john-ntpostlm.conf
PASSWD=~/hashes/crackall.git/crackme

DEBUG=0  #0 slow, 1 fast

pushd $(pwd)
cd ~marcin/hashes/crackall.git
if [ -f LM_phase1 ]; then rm LM_phase1* ; fi
if [ -f LM_phase1 ]; then rm LNT_phase1* ; fi
if [ -f LM_phase1 ]; then rm LMcracked ; fi

DICTS1=$(ls -1 dicts/Really_Quick/*)
for d in $DICTS1; do
	$JTR \
		--config=${JTRconfigLM} \
		--session=LM_phase1 \
		--pot=LM_phase1 \
		--w:$d --rules \
		--format=lm \
		$PASSWD
done

### BIGGER DICTIONARIES, still should be fast, debug only
if [ DEBUG -eq 0]; 
then
    DICTS2=$(ls -1 dicts/Quick_Lists/*)
    for d in $DICTS2; do
	    $JTR \
		  --config=${JTRconfigLM} \
		  --session=LM_phase1 \
		  --pot=LM_phase1 \
		  --w:$d \
		  --format=lm \
		  $PASSWD
    done
fi

### FOR BRUTEFORCING THE REST
echo "hit CTRL-C after 20mins or whenever the passwords stop spewing"
$JTR \
    --config=$JTRconfigLM \
    --session=LM_phase1 \
    --pot=LM_phase1 \
    --format=LM \
    $PASSWD

### extraction of cracked LM
$JTR -format=lm -show $PASSWD | \
	grep -v "password hashes cracked" | \
	sort -u | \
	cut -d: -f2 > LMcracked

### using that cracked LM list as wordlist, with different rules
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
