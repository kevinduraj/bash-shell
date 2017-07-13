#!/bin/bash
#-------------------------------------------------------------------------------------#
MYSQL="mysql -uroot -pxapian64 engine3"
#-------------------------------------------------------------------------------------#
function select2() {

  SQL2="SELECT * from engine3.keywords_health WHERE terms like '$1';";

  # echo "$SQL" | $MYSQL -t  | while read -r line
  echo "$SQL2" | $MYSQL -t -N | while read -r line
  do
    echo "$line"
  done
}
#-------------------------------------------------------------------------------------#
function delete2() {

  SQL2="DELETE from engine3.keywords_health WHERE terms like '$1';";

  # echo "$SQL" | $MYSQL -t  | while read -r line
  echo "$SQL2" | $MYSQL -t -N | while read -r line
  do
    echo "$line"
  done
}
#-------------------------------------------------------------------------------------#

select2 "$1"
sleep 5;
delete2 "$1"

