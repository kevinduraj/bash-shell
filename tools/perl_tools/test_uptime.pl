#!/usr/bin/perl
use warnings;
use strict;

my $test = `uptime`;
my @uptime = split(/\,/, $test);

my $usage = substr($uptime[3], 16);
print $usage. "<---\n";

if(int($usage) > 4) { print "\nCPU=$usage usage high\n"; }
else { print "\nCPU=$usage usage low\n"; }

