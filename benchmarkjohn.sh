#!/bin/bash


FORMATLIST="des/bsdi/md5/bf/afs/lm/nt/xsha/mscash/mscash2/hmac-md5/po/raw-md5/raw-md5-unicode/phpass-md5/dmd5/ipb2/raw-sha1/sha1-gen/raw-md4/md4-gen/krb4/krb5/mskrb5/nsldap/ssha/openssha/salted-sha/bfegg/oracle/oracle11/mysql/mysql-sha1/lotus5/dominosec/netlm/netntlm/netlmv2/netntlmv2/nethalflm/mediawiki/mschapv2/mssql/mssql05/epi/phps/mysql-fast/pix-md5/sapg/sapb/md5ns/hdaa/crypt/ssh/pdf/rar/dummy/md5-gen"
FORMATS=( $(echo $FORMATLIST | tr \/ " ") )

#echo ${FORMATS[@]}
function runbenchmark() {
rm -f johnbench.result
for f in ${FORMATS[@]} ; do
	/home/marcin/john --test --format=$f >> johnbench.result
done
}

DONTRERUN=1

[[ DONTRERUN -eq 0 ]] && runbenchmark

cat johnbench.result

