#!/bin/bash
#-------------------------------------------------------------------------------------#
MYSQL="mysql -uroot -pxapian64 engine3"
#-------------------------------------------------------------------------------------#
function table() {
   
  SQL2="SELECT terms, static, ip from engine3.keywords_health WHERE ip like '$1';";
  # echo "$SQL" | $MYSQL -t  | while read -r line
  echo "$SQL2" | $MYSQL -t -N | while read -r line
  do
    echo "$line"
  done
}
#-------------------------------------------------------------------------------------#
function fun1() {
  SQL1="SELECT ip from engine3.keywords_health WHERE terms like '$1';";
  
  $MYSQL -B -N -s -e "$SQL1" | while read -r line
  do
    echo "$line" | cut -f1   # outputs col #1
    #echo "$line" | cut -f2   # outputs col #2
    #echo "$line" | cut -f3   # outputs col #3
    #echo "$line" | cut -f4   # outputs col #4
  done

}
#-------------------------------------------------------------------------------------#
res=$(fun1 $1)
echo $res
whois "$res.0"
#-------------------------------------------------------------------------------------#
table $res
