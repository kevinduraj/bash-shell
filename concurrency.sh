#!/bin/bash
#--------------------------------------------------------------------------------------------------------#
# gosleep = $((gosleep+2))
#--------------------------------------------------------------------------------------------------------#
ENGINE='engine71'
#--------------------------------------------------------------------------------------------------------#
USERNAME='root'
PASSWORD='xapian64'
#--------------------------------------------------------------------------------------------------------#
update_tables()
{
  counter=1
  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "SHOW TABLES FROM $ENGINE"`
  for E in $TABLE_LIST
  do
      if [ "$counter" -gt "0" ]; then # skip shards ... python = int("abc", 16) + 1
      
    	  #----------------------------------------------------------------------------------------------#
          # SQL="ALTER TABLE $ENGINE.$E ADD sentence SMALLINT UNSIGNED NOT NULL DEFAULT '0' AFTER period, 
          #                             ADD words    SMALLINT UNSIGNED NOT NULL DEFAULT '0' AFTER sentence, 
          #                             ADD complex  SMALLINT UNSIGNED NOT NULL DEFAULT '0' AFTER words;"
   	  #----------------------------------------------------------------------------------------------#
          SQL="ALTER TABLE $ENGINE.$E CHANGE words words FLOAT(5,2) UNSIGNED NOT NULL DEFAULT '0';"

          #SQL="ALTER TABLE $ENGINE.$E 
          #           ADD syllables FLOAT(7,6) UNSIGNED NOT NULL DEFAULT '0' AFTER words;"
          
          #          CHANGE words words     FLOAT(4,2) UNSIGNED NOT NULL DEFAULT '0', 
          #          CHANGE complex complex FLOAT(4,2) UNSIGNED NOT NULL DEFAULT '0';" # ,
    	    
     	    # SQL="ALTER TABLE $ENGINE.$E ADD syllables FLOAT(7,5) NULL DEFAULT NULL AFTER words;"
          #SQL="ALTER TABLE $ENGINE.$E DROP spamdex, DROP sig, DROP ratio;"
    	    #--------------------------------------------------------------------------------------------#

	    flag=0
	    while [ "$flag" -eq "0" ]
	    do
	        proc=`mysqladmin -u $USERNAME -p$PASSWORD  processlist | wc | awk '{ print $1 }'`
	    
	        if [ "$proc" -lt "30" ]; then
	        	echo "$counter: $SQL"; sleep 0.1
	        	nohup mysql -u $USERNAME -p$PASSWORD -e  "$SQL" &
	            flag=1
                    sleep 0.2 
	        else
	            flag=0
	            echo "$counter: flag=$flag table=$E"
	            sleep 1
	        fi
	    done
    	   #----------------------------------------------------------------------------#
      fi 
      ((counter++))

  done
}
#---------------------------------------------------------------------------------------#
#             Repair and optimize all tables in the following databases
#---------------------------------------------------------------------------------------#

update_tables

#---------------------------------------------------------------------------------------#

