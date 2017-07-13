#!/usr/bin/perl
# Convert BerkeleyDB from Hash to Recno
# http/dev/shm/links.db://search.cpan.org/~pmqs/BerkeleyDB-0.39/BerkeleyDB.pod
#--------------------------------------------------------------------------------#
use strict;
use warnings;
use BerkeleyDB;
use Time::HiRes qw(usleep sleep);
use vars qw( %hash @array $url $value $i ) ;
$| = 1;
#--------------------------------------------------------------------------------#
my $source = "hash_japan.bdb";
my $destin = "recno_japan.bdb";
#--------------------------------------------------------------------------------#
tie %hash, "BerkeleyDB::Hash",
           -Filename => $source, 
           -Flags    => DB_RDONLY,
 or die "Cannot open file : $! $BerkeleyDB::Error\n" ;
#--------------------------------------------------------------------------------#
tie @array, 'BerkeleyDB::Recno',
            -Filename  => $destin,
            -Flags     => DB_CREATE,
            -Mode      => 0666,
or die "Cannot open file  $! $BerkeleyDB::Error\n" ;
#`chmod 666 $destin`;
#--------------------------------------------------------------------------------#

$i=0;
# print the contents of the file
while (($url, $value) = each %hash)
{
  print $i . "=" . $url . "|" . $value . "\n" if (($i%5000)==0); 
  push(@array, "$url|$value");
  $i++;
}

#--------------------------------------------------------------------------------#

print "Total=" . $i . "\n";
untie %hash;
untie @array;

#--------------------------------------------------------------------------------#

