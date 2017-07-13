#!/usr/bin/bash

RES=`netstat -tn 2>/dev/null | grep :80 | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | head -1`
count=`echo $RES | awk '{print $1}'`
ip=`echo $RES | awk '{print $2}'`
echo "$count $ip" 

if [ "$count" -ge 70 ]
then
  echo "Many connections blocking $ip"
  echo "/usr/sbin/iptables -I INPUT -s $ip -j DROP"
  /usr/sbin/iptables -I INPUT -s $ip -j DROP
else
  echo "OK"
fi  


