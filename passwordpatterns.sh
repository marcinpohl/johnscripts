#!/bin/bash
declare -r EGREP="/bin/egrep"
declare -r INPUTFILE=$1

ALLDIGITS=$( $EGREP -xc "[[:digit:]]+" $INPUTFILE )
echo "All decimal digits, 0-9: " $ALLDIGITS

HEXDIGITS=$( $EGREP -xc "[[:xdigit:]]+" $INPUTFILE )
echo "Hex digits, 0-9a-z: " $HEXDIGITS

ALPHANUMS=$( $EGREP -xc "[[:alnum:]]+" $INPUTFILE )
echo "Alphanumerical, 0-9a-zA-Z: " $ALPHANUMS

ALLLOWER=$(  $EGREP -xc "[[:lower:]]+" $INPUTFILE )
echo "All lowercase, a-z: " $ALLLOWER

ALLUPPER=$(  $EGREP -xc "[[:upper:]]+" $INPUTFILE )
echo "All uppercase, A-Z: " $ALLUPPER

CAPITALIZED=$( $EGREP -xc "[[:upper:][:lower:]]+" $INPUTFILE )
echo "Capitalized, Start with UPPER, then all lower: " $CAPITALIZED

DOUBLECAPTITALIZED=$( $EGREP -xc "[[:upper:]][[:upper:][:lower:]]+" $INPUTFILE )
echo "Double Capitalized, Start with two UPPERs, then all lower: " $DOUBLECAPITALIZED

UPPERALPHA=$( $EGREP -xc "[[:upper:]][[:alpha:]]+" $INPUTFILE )
echo "Start Capitalized, Start with capitalized with UPPER/LOWER afterwards: " $UPPERALPHA

UPPERALPHASDIGIT=$( $EGREP -xc "[[:upper:]][[:lower:]]+[[:digit:]]" $INPUTFILE )
echo "Capitalized with end digit, Capitalized word with a single digit at the end: " $UPPERALPHADIGIT

UPPERALPHASDIGITS=$( $EGREP -xc "[[:upper:]][[:lower:]]+[[:digit:]]+" $INPUTFILE )
echo "Capitalized with end digits, Capitalized word with a multiple digits at the end: " $UPPERALPHADIGITS

DIGITSTRING=$( $EGREP -xc "[[:digit:]][[:alpha:]]+" $INPUTFILE )
echo "Digit String, Starts with a single digit and UPPER/LOWER afterwards: " $DIGITSTRING

DIGITSSTRING=$( $EGREP -xc "[[:digit:]]+[[:alpha:]]+" $INPUTFILE )
echo "Digits String, Starts with a multiple digits and UPPER/LOWER afterwards: " $DIGITSSTRING

ALLCNTRL=$( $EGREP -xc "[[:cntrl:]]+" $INPUTFILE )
echo "All control characters: " $ALLCNTRL

ALLGRAPH=$( $EGREP -xc "[[:graph:]]+" $INPUTFILE )
echo "All graph characters: " $ALLGRAPH

ALLPUNCT=$( $EGREP -xc "[[:punct:]]+" $INPUTFILE )
echo "All punctuation characters: " $ALLPUNCT

LOWERANDPUNCT=$( $EGREP -xc "[[:lower:][:punct:]]+" $INPUTFILE )
echo "All punctuation and lower characters: " $LOWERANDPUNCT

UPPERANDPUNCT=$( $EGREP -xc "[[:upper:][:punct:]]+" $INPUTFILE )
echo "All punctuation and upper characters: " $UPPERANDPUNCT

ALPHAANDPUNCT=$( $EGREP -xc "[[:alpha:][:punct:]]+" $INPUTFILE )
echo "All punctuation and upper and lower characters: " $ALPHAANDPUNCT

ALNUMANDPUNCT=$( $EGREP -xc "[[:alnum:][:punct:]]+" $INPUTFILE )
echo "All punctuation and upper and lower and digits characters: " $ALNUMANDPUNCT

ALNUMANDPUNCTANDSPACE=$( $EGREP -xc "[[:alnum:][:punct:][:space:]]+" $INPUTFILE )
echo "All punctuation, alphanumerics, and space characters: " $ALNUMANDPUNCTANDSPACE
#[:cntrl:]  [:graph:] [:print:]  [:punct:] [:space:] 
echo "*** Password length stats ***"
for i in $(seq 1 25) 
do 
	echo -n "Password Length "$i " " 
	$EGREP -xc ".{$i}" "$INPUTFILE" 
done

echo "*** particular masks ***"
PATTERN001=$( $EGREP -xc "[[:lower:]+[:punct:][:digit:]{1}]" $INPUTFILE )
PATTERN002=$( $EGREP -xc "[[:lower:]+[:punct:][:digit:]{2}]" $INPUTFILE )
PATTERN003=$( $EGREP -xc "[[:lower:]+[:punct:][:digit:]{3}]" $INPUTFILE )
PATTERN004=$( $EGREP -xc "[[:lower:]+[:punct:][:digit:]{4}]" $INPUTFILE )
PATTERN005=$( $EGREP -xc "[[:lower:]+[:punct:][:digit:]{5}]" $INPUTFILE )

for p in $(seq 1 5)
do
	echo ${PATTERN00$p}
done
