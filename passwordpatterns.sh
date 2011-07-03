#!/bin/bash
declare -r EGREP="/bin/egrep"
declare -r INPUTFILE=$1

ALLDIGITS=$( $EGREP -xc "[[:xdigit:]]+" $INPUTFILE )
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

UPPERALPHASDIGIT=$( $EGREP -xc "[[:upper:]][[:alpha:]]+[[:digit:]]" $INPUTFILE )
echo "Capitalized with end digit, Capitalized word with a single digit at the end: " $UPPERALPHADIGIT

UPPERALPHASDIGITS=$( $EGREP -xc "[[:upper:]][[:alpha:]]+[[:digit:]]+" $INPUTFILE )
echo "Capitalized with end digits, Capitalized word with a multiple digits at the end: " $UPPERALPHADIGITS

#[:cntrl:]  [:graph:] [:print:]  [:punct:] [:space:] 
