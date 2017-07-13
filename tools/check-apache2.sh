#!/bin/bash
#---------------------------------------------------------------------------------------------#
# curl --write-out %{http_code} --silent --output /dev/null localhost
#---------------------------------------------------------------------------------------------#

if netcat pacific-design.com 80 <<EOF | awk 'NR==1{if ($2 == "500") exit 0; exit 1;}'; then
GET / HTTP/1.1
Host: pacific-design.com 

EOF

    apache2ctl restart;
fi
#---------------------------------------------------------------------------------------------#
