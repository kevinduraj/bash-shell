#!/bin/bash
# Usage:
# cat test.txt | xargs -n1  ./extract_domain.sh
#-------------------------------------------------------------------#
MYURL=$1
awk -F/ '{ print $3 }' <<< $MYURL | awk -F. '{ if ( $(NF-1) == "co" || $(NF-1) == "com" ) printf $(NF-2)"."; print $(NF-1)"."$(NF); }'

