#!/bin/bash
#-----------------------------------------------------------------------------------#
USERNAME='root'
PASSWORD='xapian64'
DB='engine75_new'
SERVER='localhost'
#SERVER='108.210.29.50'
#-----------------------------------------------------------------------------------#
#                           Drop Database
#-----------------------------------------------------------------------------------#
recreate_database()
{
  SQL="DROP DATABASE $DB;"
  echo $SQL
  RES=`mysql -h $SERVER -u $USERNAME -p$PASSWORD -NB -e "$SQL"`
  echo $RES 
  
  sleep 1 

  SQL="CREATE DATABASE $DB DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
  echo $SQL
  RES=`mysql -h $SERVER -u $USERNAME -p$PASSWORD -NB -e "$SQL"`
  echo $RES 
}
#-----------------------------------------------------------------------------------#
#                                 Create Tables
#-----------------------------------------------------------------------------------#
create_tables()
{
SQL="
CREATE TABLE $DB.part_$1 (
  sha256url 	char(64) 	CHARACTER SET ascii NOT NULL,
  md5root 	char(32) 	CHARACTER SET ascii NOT NULL,

  url 		varchar(255) 	NOT NULL,
  root 		varchar(64) 	NOT NULL,

  tags 		varchar(128) 	DEFAULT NULL,
  title 	varchar(128) 	DEFAULT NULL,
  body 		varchar(4096) 	DEFAULT NULL,
  alexa 	mediumint(6) 	DEFAULT NULL,
  rank 		mediumint(6) 	DEFAULT NULL,
  hit1 		mediumint(6) 	DEFAULT NULL,
  hit2 		mediumint(6) 	DEFAULT NULL,
  hit3 		mediumint(6) 	DEFAULT NULL,
  category 	char(3) 	DEFAULT NULL,
  period 	date 		DEFAULT NULL,

  gunning       float(5,2)      NOT NULL DEFAULT '0.00', 
  flesch        float(5,2)      NOT NULL DEFAULT '0.00', 
  kincaid       float(5,2)      NOT NULL DEFAULT '0.00', 
  
  sentence 	smallint(5)	UNSIGNED NOT NULL DEFAULT '0',
  words 	float(5,2) 	UNSIGNED NOT NULL DEFAULT '0.00',
  syllables 	float(7,6) 	UNSIGNED NOT NULL DEFAULT '0.000000',
  complex 	float(4,2) 	UNSIGNED NOT NULL DEFAULT '0.00'

) ENGINE=MyISAM DEFAULT CHARSET=utf8;
"

 # period DATETIME NOT NULL DEFAULT NOW()
 echo $SQL
 RES=`mysql -h $SERVER -u $USERNAME -p$PASSWORD -NB -e "$SQL"`
 echo $RES 

}
#-----------------------------------------------------------------------------------#
#                              Partition Tables
#-----------------------------------------------------------------------------------#
make_partitions()
{

  list=`echo {{0..9},{a..f}}`

  for one in $list; do
    for two in $list; do
      for three in $list; do
        create_tables $one$two$three
      done
    done
  done

}
#-----------------------------------------------------------------------------------#
#                                  Main 
#-----------------------------------------------------------------------------------#

recreate_database
make_partitions

#-----------------------------------------------------------------------------------#
