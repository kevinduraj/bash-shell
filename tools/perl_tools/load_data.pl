#!/usr/bin/perl
# http/dev/shm/links.db://search.cpan.org/~pmqs/BerkeleyDB-0.39/BerkeleyDB.pod
#--------------------------------------------------------------------------------#
use strict;
use warnings;
use BerkeleyDB;
use vars qw( %h $k $v $total $elements ) ;
my $file;
$| = 1;
#--------------------------------------------------------------------------------#
my $database = "/dev/shm/hash_linkedin.bdb";
#--------------------------------------------------------------------------------#
 tie %h, "BerkeleyDB::Hash",
           -Filename  => $database,
           -Flags     => DB_CREATE,
 or die "Cannot open file $database: $! $BerkeleyDB::Error\n" ;
#--------------------------------------------------------------------------------#
my @array = ();
for('09'..'14') { push(@array, $_); }
@array = reverse(@array);
foreach(@array)
{
  $file  = "/data1/spider/links0$_.dat"; 
  print $file . "\n";
  &load_data($file);
}
#--------------------------------------------------------------------------------#
print "Total Records=" . $total . "\n";
#--------------------------------------------------------------------------------#
sub load_data
{
  my $sourcefile = shift;
  open(FILE, $sourcefile);

  while(<FILE>)
  {
    chomp($_);
    my $pos = index($_, 'http');
    my $url = substr($_, $pos);
    $url    =~ s/\s+//g;

    if(
         ($url =~ /(linkedin)/) &&
         ($url !~ /(allexperts|bnet|zdnet|doubleclick|quantcast|msplinks)/) &&
         ($url !~ /(\?|\#|\@|\!|\%|\.\.\.|rss|\.xml|\.jpg|\.zip|\.tar|\.gif)/) &&
         ($url !~ /(tinyurl|\.ly\/|\.gd\/|\.im\/|\.mp\/|\.cc\/)/) &&
         ($url !~ /(subscribe|signup|login|register|feed)/) &&
         (length($url) < 200)
      )
      {
       #"http://www.linkedin.com/pub/dir/Chris/Schmeltzer/?trk=ppro_find_others";
       my $end = rindex($url, "trk=") - 1 ;
       if($end > 0) { $url = substr($url, 0, $end); }

       if(length($url) > 25)
       {
         $h{$url}++;
         if($h{$url} == 1) { $elements ++; } 
         $total++;

         if(($total%1000)==0) 
         {
           print $total . "\t" . $sourcefile . "\n" ;
           print $elements . "\t" . $url . "\n\n";
           if($elements > 5000000) { exit; }
         }
       } 
     }
  }

  close(FILE);

}
END {

  print "END detected ...";
  untie %h ;
  `mv $database .`;
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

