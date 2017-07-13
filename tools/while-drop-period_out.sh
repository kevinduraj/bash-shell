#!/bin/bash
#-------------------------------------------------------------------------------------#
# python = int("b5f", 15)
# ((gosleep++))
# gosleep=$((gosleep+2)) 
#-------------------------------------------------------------------------------------#
USERNAME='root'
PASSWORD='xapian64'
#-------------------------------------------------------------------------------------#
alter_tables()
{
  DATABASE=$1
  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "SHOW TABLES FROM $DATABASE"`
  counter=0; gosleep=0; last=0; 

  for E in $TABLE_LIST
  do

        flag=0
	while [ "$flag" -eq "0" ]
	do
	    proc=`mysqladmin -uroot -pxapian64  processlist | wc | awk '{ print $1 }'`
	
	    #-------------------------------------------------------------------------#
	    if [ "$proc" -lt "32" ]; then
	    	#-------------------------------------------------------#
	    	SQL="ALTER TABLE $DATABASE.$E DROP period_out;"
	    	#-------------------------------------------------------#
	    	echo "$counter: $SQL"; sleep 0.1
	    	nohup mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL" &
	        flag=1
	    else
	        flag=0
                echo "$counter: flag=$flag table=$E"
	        sleep 5
	    fi
	    #-------------------------------------------------------------------------#
	done


    ((counter++))
   
  done

}
#-------------------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#-------------------------------------------------------------------------------------#
mydb="engine22"
for db in $mydb
do  
    echo "Database: is [$db]"
    alter_tables $db
done
#--------------------------------------------------------------------------------------#

