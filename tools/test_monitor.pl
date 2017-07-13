#!/usr/bin/perl
use strict;
use warnings;

#my $res = `uptime | awk -F 'load average: ' '{print \$2}' | awk -F '.' '{print \$1}'`;
my $res = system("uptime | awk -F 'load average: ' '{print \$2}' | awk -F '.' '{print \$1}'");

print $res;

if($res > 0) {
     $res = system("killall mapper.pl");
}

