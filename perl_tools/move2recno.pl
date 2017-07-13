#!/usr/bin/perl
# http/dev/shm/links.db://search.cpan.org/~pmqs/BerkeleyDB-0.39/BerkeleyDB.pod
#--------------------------------------------------------------------------------#
use strict;
use warnings;
use BerkeleyDB;
use Time::HiRes qw(usleep sleep);
use vars qw( %hash @array $url $value $i ) ;
$| = 1;
#--------------------------------------------------------------------------------#
my $source="hash_linkedin.bdb";
my $destination="/data1/recno_seq1.bdb";
unlink($destination);
#--------------------------------------------------------------------------------#
tie %hash, "BerkeleyDB::Hash",
           -Filename => $source, 
           -Flags    => DB_RDONLY
 or die "Cannot open file : $! $BerkeleyDB::Error\n" ;
#--------------------------------------------------------------------------------#
tie @array, 'BerkeleyDB::Recno',
            -Filename  => $destination,
            -Flags     => DB_CREATE,
            -Mode      => 0666,
or die "Cannot open file  $! $BerkeleyDB::Error\n" ;
`chmod 666 $destination`;
#--------------------------------------------------------------------------------#

$i=0;
# print the contents of the file
while (($url, $value) = each %hash)
{
  $value = 1 unless $value;
  print $i . "=" . $url . "|" . $value . "\n" if (($i%5000)==0); 
  push(@array, "$url|$value");
  $i++;
}

#--------------------------------------------------------------------------------#

print "Total=" . $i . "\n";
untie %hash;
untie @array;

#--------------------------------------------------------------------------------#
