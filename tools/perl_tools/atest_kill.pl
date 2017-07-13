#!/usr/bin/perl
use strict;

my $script = 'memory_test.pl';
my ($proc, $size) = split(/ /, `ps -aylC $script | grep $script | awk '{ print \$3 " " \$8 }' | sort -n | tail -1`);
print "script=" . $script .  " proc=" . $proc . " size=" . $size . "\n"; 

if($size > 50000)
{
  print "kill -9 $proc\n";
  my $res = `kill -9 $proc`;
}  
