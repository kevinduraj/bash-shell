#!/usr/bin/perl
use strict;
use warnings;
#--------------------------------------------------------------#
use BerkeleyDB;

my $filename = "/home/spider/data/merged_50.bdb";
#---------------------------------------------------------------#
use vars qw( @prod $i $url $val);
tie @prod, 'BerkeleyDB::Recno',
  -Filename => $filename,
  -Flags    => 'DB_RDONLY',
  -Property => 'DB_RENUMBER'
  or die "Cannot open $filename: $!\n";

our $LAST = @prod;

for($i=32900235; $i < $LAST; $i++)
{
  ($url, $val) = split(/\|/, $prod[$i]);
  print $url . "\n";
}

#---------------------------------------------------------------#
