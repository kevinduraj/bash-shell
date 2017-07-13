#!/bin/bash
#-------------------------------------------------------------------------------#
#           Detection of Denial Attack on SSH port auth.log
#-------------------------------------------------------------------------------#
cat /var/log/auth.log | grep "refused connect" | awk '{print $9}' | tee > temp1 
sort temp1 | tee temp2 &> /dev/null;
uniq -c temp2 | sort -n | tee refused_connect.txt
rm temp1 temp2

#-------------------------------------------------------------------------------#
#           Read $FILE using the file descriptors
#-------------------------------------------------------------------------------#
FILE='refused_connect.txt'
exec 3<&0
exec 0<$FILE
while read line
do 
    counter=`echo $line | awk '{print $1}'`
    
    if [ "$counter" -ge 20 ]; then 

        #echo $line | mail -s "WARNING! $(date +\%F_\%H:\%M)" kevinduraj@gmail.com

        IP=$(echo $line | awk '{print $2}')
        echo "/sbin/iptables -I INPUT -s $IP -j DROP"
        /sbin/iptables -I INPUT -s $IP -j DROP
        echo > /var/log/auth.log
    fi  
done
exec 0<&3
#-------------------------------------------------------------------------------#

