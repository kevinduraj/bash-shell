#!/bin/bash

input='health-keyword.dat'
output='health-links.dat'
#---------------------------------------------------------------------------------------#
#m -e "select terms from engine3.keywords_health WHERE static > 9" | tee $input &> /dev/null
#---------------------------------------------------------------------------------------#

sed -i "/'/d" $input
cat $input | tr -s " " "\012" | tee 1.d

perl -i.bak -pe 's/[^[:ascii:]]//g' 1.d
sed -i '/[0-9]/d;' 1.d
sed -i -r '/^.{,5}$/d' 1.d 
sort -S 8G -u 1.d | tee 2.d

#---------------------------------------------------------------------------------------#
split -n 2 2.d
#---------------------------------------------------------------------------------------#

file='xaa'
sed -i -r '/^.{,5}$/d' $file
cat $file | tr -s " " "\012" | paste -s -d '|' | tee $file.d 
line=$(head -n 1 $file.d)
nohup nice grep -E "$line" health3.dat  | tee -a $output &> /dev/null &

#---------------------------------------------------------------------------------------#

file='xab'
sed -i -r '/^.{,5}$/d' $file
cat $file | tr -s " " "\012" | paste -s -d '|' | tee $file.d 
line=$(head -n 1 $file.d)
nohup nice grep -E "$line" health3.dat  | tee -a $output &> /dev/null &

#---------------------------------------------------------------------------------------#
# display 12 char words
#cat 1.d | grep -o -w -E '^[[:alnum:]]{12}' | tee 1
#---------------------------------------------------------------------------------------#
