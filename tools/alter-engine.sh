#!/bin/bash
#--------------------------------------------------------------------------------------#
# python = int("b5f", 15)
# gosleep=$((gosleep+2)) 
#--------------------------------------------------------------------------------------#
USERNAME='root'
PASSWORD='xapian64'
#--------------------------------------------------------------------------------------#
alter_tables()
{
  DATABASE=$1
  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "SHOW TABLES FROM $DATABASE"`
  counter=0; gosleep=0; last=0;

  for E in $TABLE_LIST
  do
    proc=`mysqladmin -uroot -pxapian64  processlist | wc | awk '{ print $1 }'`

    #----------------------------------#
    if [ "$proc" -le "5" ]; then
    	gosleep=0
    else
    	if [ "$proc" -lt "$last" ]; then
    		((gosleep--))
    	else
    		((gosleep++))
    	fi
    fi
    #----------------------------------#
   

    #---------------------------------------------------------------------------------------------------------------------#
    SQL="ALTER TABLE $DATABASE.$E CHANGE md5url sha256url CHAR(64) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL;"
    # SQL="ALTER TABLE $DATABASE.$E CHANGE hits hits MEDIUMINT(6) NULL DEFAULT NULL;"

    echo "$SQL"; sleep 0.05
    nohup mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL" &
        
    #---------------------------------------------------------------------------------------------------------------------#
    last=$proc
    sleep $gosleep      
    ((counter++))

  done
}
#--------------------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#--------------------------------------------------------------------------------------#
mydb="engine22"
for db in $mydb
do  
    echo "Database: is [$db]"
    alter_tables $db
done
#--------------------------------------------------------------------------------------#

