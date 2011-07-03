$!/bin/gawk

BEGIN { 	
		RS="\n\n+"
		#FS="/^Benchmarking/" 
		FS="..." 
		print " Field separator is ", FS
		OFS="|EOF|\n" 
		ORS="_EOR_\n\n"
}

NF
#NF==4 { print $1,$2,$3,$4 }
#NF==3 { print $2,$3 }

#END { print NR }

