#!/usr/bin/bash
#-------------------------------------------------------------------------------#
#           Detection of Denial Attack on SSH port auth.log
#-------------------------------------------------------------------------------#
connection() {
  
  FILE1="/var/log/secure"

  cat $FILE1 | grep "Failed password" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'  | tee temp1 &> /dev/null;
  sort temp1 | tee temp2 &> /dev/null;
  uniq -c temp2 | sort -n | tee refused_connect.txt
  rm temp1 temp2

  #----------------------------------------------------------------------------#
  FILE2='refused_connect.txt'
  exec 3<&0
  exec 0<$FILE2

  while read line
  do 
    counter=`echo $line | awk '{print $1}'`
    
    if [ "$counter" -ge 10 ]; then 

        #echo $line | mail -s "WARNING! $(date +\%F_\%H:\%M)" kevinduraj@gmail.com
       	IP=$(echo $line | awk '{print $2}')
       
 	      echo "/usr/sbin/iptables -I INPUT -s $IP -j DROP"
      	/usr/sbin/iptables -I INPUT -s $IP -j DROP

       	echo > $FILE1
    fi

  done
  exec 0<&3
  #----------------------------------------------------------------------------#

}
#-------------------------------------------------------------------------------#
echo "Checking Connection"
connection;

