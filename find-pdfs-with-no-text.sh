#!/bin/sh

PDF2TXT=`which pdftotext`

if [ ! -e "$PDF2TXT" ]
then
    echo "Executable pdftotext not found"
    echo "Download it from http://www.bluem.net/en/mac/others/ or compile it from http://www.foolabs.com/xpdf/"
    exit 1
fi

#echo $#
if [ $# -gt 0 ]
then
    echo "Checking for command to process un-OCRed PDFs"
    
    if [ ! -e "$1" ]
    then
        echo "Executable '$1' not found. Please make sure the file exists."
        #exit 1
    fi
fi

BASE=`pwd`

echo "Looking for PDFs in directory $BASE"

for i in *.pdf
do
    LINES=`$PDF2TXT -q "$i" - | wc -l`
	
	if [ -z "$LINES" ]
	then
	    # Very weird, should not happen at all
	    echo "Empty line count for file $i. Number [0-9]+ expected"
	    exit 1
    	fi
	
	if [ $LINES -gt 0 ]
	then
	    # PDF contains 1 or more lines of text
		continue
	fi
	
	ABSPATH="$BASE/$i"
    
    echo "$ABSPATH"
    echo "File '$i' seems not be OCRed yet ($LINES lines of text)"
    
    if [ $# -gt 0 ]
    then
	echo "Executing $1 '$ABSPATH'"
	$1 "$ABSPATH"
    fi
done

exit 0
