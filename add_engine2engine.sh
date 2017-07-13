#!/bin/bash
#------------------------------------------------------------------------------------#
USERNAME='root'
PASSWORD='xapian64'

DATABASES='engine71'
DESTINATION='engine73'
#------------------------------------------------------------------------------------#

for DATABASE in $DATABASES
do  
  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "SHOW TABLES FROM $DATABASE"`

  for E in $TABLE_LIST
  do
      SQL="INSERT INTO $DESTINATION.$E 
           SELECT 
		sha256url
		, md5root
		, url
		, root
		, tags
		, title
		, body
		, rank
		, nlp
		, 0 
		, 0
		, 0
		, period 
		, '2009-05-01'
		, 0
		, 0
		, 0
		, 0
           FROM $DATABASE.$E "
      echo "$SQL"
      RES=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`
      echo "$RES"
  done
done

#------------------------------------------------------------------------------------#
