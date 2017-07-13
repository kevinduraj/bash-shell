#!/bin/bash
#---------------------------------------------------------------------------------------#
# gosleep = $((gosleep+2))
#---------------------------------------------------------------------------------------#
SOURCE='engine22'
DESTIN='engine23'
FINAL1='engine24'
#---------------------------------------------------------------------------------------#
USERNAME='root'
PASSWORD='xapian64'
#---------------------------------------------------------------------------------------#
move_tables()
{
  SQL="CREATE DATABASE $DESTIN DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
  echo $SQL
  RES=`mysql -u $USERNAME -p$PASSWORD -NB -e "$SQL"`
  echo $RES

  counter=0
  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "show tables from $SOURCE"`
  for E in $TABLE_LIST
  do
      if [ "$counter" -gt "3824" ]; then # skip shards ... python = int("3773", 16)
      
      	    SQL="CREATE TABLE $DESTIN.$E SELECT * FROM $SOURCE.$E ORDER BY period DESC;"

    	    #----------------------------------------------------------------------------#
	    flag=0
	    while [ "$flag" -eq "0" ]
	    do
	        proc=`mysqladmin -uroot -pxapian64  processlist | wc | awk '{ print $1 }'`
	    
	        if [ "$proc" -lt "20" ]; then
	        	echo "$counter: $SQL"; sleep 1
	        	nohup mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL" &
	            flag=1
	        else
	            flag=0
	            echo "$counter: flag=$flag table=$E"
	            sleep 5
	        fi
	    done
    	    #----------------------------------------------------------------------------#
      fi 
      ((counter++))

  done
}
#---------------------------------------------------------------------------------------#
compute_tables()
{
  counter=0
  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "SHOW TABLES FROM $DESTIN"`
  for E in $TABLE_LIST
  do

    	SQL="INSERT INTO $FINAL1.$E
          SELECT DISTINCT (sha256url)
          ,md5root
          ,url
          ,root
          ,tags
          ,title
          ,body
          ,kincaid
          ,flesch
          ,fog
          ,spamdex
          ,sig
          ,ratio
          ,period
          ,AVG(rank) rank
          ,nlp
          ,SUM(hits) hits
        FROM $DESTIN.$E 
        GROUP BY sha256url"
	
	#---------------------------------------------------------------------------#
        flag=0
	while [ "$flag" -eq "0" ]
	do
	    proc=`mysqladmin -uroot -pxapian64  processlist | wc | awk '{ print $1 }'`
	
	    if [ "$proc" -lt "20" ]; then
	    	echo "$counter: $SQL"; 
	    	nohup mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL" &
	        flag=1
	    else
	        flag=0
	        echo "$counter: flag=$flag table=$E"
	        sleep 5 
	    fi
	done
    	((counter++))
	#---------------------------------------------------------------------------#

  done

}
#---------------------------------------------------------------------------------------#
#             Repair and optimize all tables in the following databases
#---------------------------------------------------------------------------------------#

move_tables
compute_tables

#---------------------------------------------------------------------------------------#

