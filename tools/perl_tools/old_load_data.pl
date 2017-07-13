#!/usr/bin/perl
# http/dev/shm/links.db://search.cpan.org/~pmqs/BerkeleyDB-0.39/BerkeleyDB.pod
#--------------------------------------------------------------------------------#
use strict;
use warnings;
use BerkeleyDB;
use vars qw( %h $k $v $i ) ;
$| = 1;
#--------------------------------------------------------------------------------#
my $database = "/data1/google_links.bdb";
#--------------------------------------------------------------------------------#
#unlink($database);
  tie %h, "BerkeleyDB::Hash",
           -Filename  => $database,
           -Flags     => DB_CREATE,
           -Cachesize => 1073741824,
 or die "Cannot open file $database: $! $BerkeleyDB::Error\n" ;
#--------------------------------------------------------------------------------#

&load_data("/data1/spider/links.dat"); 

print "Total=" . $i . "\n";
untie %h ;

#--------------------------------------------------------------------------------#
sub load_data
{
  my $sourcefile = shift;
  $i=0;
  open(FILE, $sourcefile);

  while(<FILE>)
  {
    chomp($_);
    my $pos = index($_, 'http');
    my $url = substr($_, $pos);
    $url    =~ s/\s+//g;

    #if((/linedin/) && ($url !~ /\?/) && (length($url) < 128))
    if(($_ =~/linkedin/) && ($_ !~ /(shareArticle|https|login|register|authToken|sharedKey|scribd|urlhash)/))
    {
       #"http://www.linkedin.com/pub/dir/Chris/Schmeltzer/?trk=ppro_find_others";
       my $end = rindex($url, "trk=") - 1 ;
       if($end > 0) { $url = substr($url, 0, $end); }

       $h{$url}++; $i++;
       print "in $i=" . $url . "\n" if(($i%1000)==0);
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

