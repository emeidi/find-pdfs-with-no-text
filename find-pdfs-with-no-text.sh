#!/bin/sh

PDF2TXT=`which pdftotext`
ASCRIPT=`which osascript`

if [ ! -e "$PDF2TXT" ]
then
    echo "Executable pdftotext not found"
    echo "Download it from http://www.bluem.net/en/mac/others/ or compile it from http://www.foolabs.com/xpdf/"
    exit 1
fi

if [ ! -e "$ASCRIPT" ]
then
    echo "Executable osascript not found"
    echo "Are you running this script on Mac OS X? Is PATH set appropriatly?"
    exit 1
fi

# Script to call when un-ocred PDF is found
OCRSCRIPT="/Users/mario/ocr.scpt"
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
    
    echo "File $i seems not be OCRed yet ($LINES lines of text)"
    
    # Pass file to an AppleScript file ...
    #echo "Calling Adobe Acrobat: $ASCRIPT '$OCRSCRIPT' '$ABSPATH'"
	#$ASCRIPT "$OCRSCRIPT" "$ABSPATH"
	
	# Or simply open it
	open -a "Adobe Acrobat Pro" "$ABSPATH"
done

exit 0
