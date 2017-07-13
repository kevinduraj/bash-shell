#!/bin/bash

TERM=$1
echo "mysql -uroot -pxapian64 -e \"DELETE from engine3.keywords_health WHERE terms like '%${TERM}%';\""
mysql -uroot -pxapian64 -e "DELETE from engine3.keywords_health WHERE terms like '%${TERM}%';"
