#!/bin/bash
#-------------------------------------------------------------------------------#

NOW=$(date +"%Y-%m-%d %T")
CNT=`/usr/sbin/lsof -u spider | wc -l`

#-------------------------------------------------------------------------------#

header=`echo "Spider Open Files: " $CNT`
line=`echo "Spider Open Files: " $CNT " - DateTime: " $NOW`

echo $line
#echo $line | mail -s "$header" kevinduraj@gmail.com #, \

#-------------------------------------------------------------------------------#

