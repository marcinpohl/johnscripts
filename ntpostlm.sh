#!/bin/bash
set +x
set +e
shopt -u dotglob         
shopt -s extglob         
shopt -u failglob       
shopt -u globstar      
shopt -u nocaseglob   
shopt -u nullglob    

pushd $(pwd)
cd ~marcin/hashes/crackall.git
rm LM_phase1* NT_phase1* LMcracked

DICTS=$(ls -1 dicts/*)
for d in $DICTS; do
	jtr/john \
		--config=jtr/john.conf \
		--session=LM_phase1 \
		--pot=LM_phase1 \
		--w:$d --rules \
		--format=LM \
		crackme
done

### BIGGER DICTIONARIES, still should be fast, debug only
DICTSBAK=$(ls -1 dicts.bak/*)
for d in $DICTSBAK; do
	jtr/john \
	   --config=jtr/john.conf \
	   --session=LM_phase1 \
	   --pot=LM_phase1 \
	   --w:$d \
	   --format=LM \
	   crackme
done

### FOR BRUTEFORCING THE REST
echo "hit CTRL-C after 20mins or whenever the passwords stop spewing"
	jtr/john \
	   --config=jtr/john.conf \
	   --session=LM_phase1 \
	   --pot=LM_phase1 \
	   --format=LM \
	   crackme

### extraction of cracked LM
jtr/john -format=LM -show crackme | \
	grep -v "password hashes cracked" | \
	sort -u | \
	cut -d: -f2 > LMcracked

### using that cracked LM list as wordlist, with different rules
jtr/john \
	--config=jtr/john-ntpostlm.conf \
	--session=NT_phase1 \
	--pot=NT_phase1 \
	--w:LMcracked --rules \
	--format=nt \
	crackme
# output some stats
echo -n "LanMan stats: "
jtr/john -show -format=LM crackme | tail -n1
echo -n "NTLM stats: "
jtr/john -show -format=nt crackme | tail -n1

#return to whatever was before
popd
