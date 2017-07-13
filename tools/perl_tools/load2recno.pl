#!/usr/bin/perl
# http/dev/shm/links.db://search.cpan.org/~pmqs/BerkeleyDB-0.39/BerkeleyDB.pod
#--------------------------------------------------------------------------------#
use strict;
use warnings;
use BerkeleyDB;
use Time::HiRes qw(usleep sleep);
use vars qw( @array ) ;
$| = 1;
#--------------------------------------------------------------------------------#
my $destination="/data1/logs/all_data.bdb";
#--------------------------------------------------------------------------------#
tie @array, 'BerkeleyDB::Recno',
            -Filename  => $destination,
            -Flags     => DB_CREATE,
or die "Cannot open file  $! $BerkeleyDB::Error\n" ;
#--------------------------------------------------------------------------------#
my ($value, $i) = (10, 0);

open(FILE, "/data1/logs/all_data.log") or die $!;
while(<FILE>)
{
  chomp;
  print $i . "=" . $_ . "|" . $value . "\n" if (($i%10000)==0);
  push(@array, "$_|$value");
  $i++;
}
close(FILE);

#--------------------------------------------------------------------------------#

print "Total=" . $i . "\n";
untie @array;

#--------------------------------------------------------------------------------#

