#!/usr/bin/bash

#iptables -I INPUT -s 66.249.75.0/24 -j DROP
echo "iptables -I INPUT -s $1 -j DROP"
iptables -I INPUT -s $1 -j DROP

#iptables -I INPUT -m iprange --src-range $1 -j DROP

# Ctrl-V
# :
# !sort -k6 -n
# Enter

# iptables-save > /etc/iptables.rules
# iptables-restore < /etc/iptables.rules
iptables -L -n | less

