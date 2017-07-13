#!/usr/bin/perl
# http/dev/shm/links.db://search.cpan.org/~pmqs/BerkeleyDB-0.39/BerkeleyDB.pod
#--------------------------------------------------------------------------------#
use strict;
use warnings;
use BerkeleyDB;
use Time::HiRes qw(usleep sleep);
use vars qw( %h $k $v $i ) ;
$| = 1;
#--------------------------------------------------------------------------------#
my $sourcefile = "/data1/spider/links.dat";
my $database   = "/data1/google_links.bdb";
#--------------------------------------------------------------------------------#
 tie %h, "BerkeleyDB::Hash",
           -Filename  => $database,
           -Flags     => DB_CREATE,
           -Cachesize => 1073741824,
 or die "Cannot open file $database: $! $BerkeleyDB::Error\n" ;
#--------------------------------------------------------------------------------#

&load_data(); 

print "Total records = $i\n";

untie %h ;

#--------------------------------------------------------------------------------#
sub load_data
{

  $i=0;
  open(FILE, $sourcefile);

  while(<FILE>)
  {

    if(($_ =~/linkedin/) && ($_ !~ /(shareArticle|https|login|register|authToken|sharedKey|scribd|urlhash)/))
    {
      my @array = ();
      chomp($_);
      my $pos = index($_, 'http');
      my $url = substr($_, $pos);
      $url    =~ s/\s+//g;

      $h{$url} = "1"; $i++;
      print "in $i=" . $url . "\n" if(($i%5000)==0);
    }
  }

  close(FILE);

}
#--------------------------------------------------------------------------------#
__END__

close(FILE2);
# Add a few key/value pairs to the file
$h{"apple"} = "red" ;
$h{"orange"} = "orange" ;
$h{"banana"} = "yellow" ;
$h{"tomato"} = "red" ;

# Check for existence of a key
print "Banana Exists\n\n" if $h{"banana"} ;

# Delete a key/value pair.
delete $h{"apple"} ;

