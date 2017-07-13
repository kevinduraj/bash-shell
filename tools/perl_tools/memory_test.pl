#!/usr/bin/perl
use strict;
use warnings;
#--------------------------------------------------------------#
sub limit_memory
{
  my $file = __FILE__;
  my $script = substr($file, 2);
  my ($proc, $size) = split(/ /, `ps -aylC $script | grep $script | awk '{ print \$3 " " \$8 }' | sort -n | tail -1`);
  print "script=" . $script .  " proc=" . $proc . " size=" . $size . "\n";

  if($size > 50000)
  {
    print "kill -9 $proc\n";
    my $res = `kill -9 $proc`;
  }
  sleep 3;
}
#--------------------------------------------------------------#
sub generate_random_string
{
  my $length_of_randomstring=shift;# the length of 
       # the random string to generate

  my @chars=('a'..'z','A'..'Z','0'..'9','_');
  my $random_string;
  foreach (1..$length_of_randomstring) 
  {
    # rand @chars will generate a random 
    # number between 0 and scalar @chars
    $random_string.=$chars[rand @chars];
  }
  return $random_string;
}
#--------------------------------------------------------------#
&limit_memory();
#--------------------------------------------------------------#
my $random_string;
my @array = ();
for(1..1000)
{
  for(1..10000)
  { 
    my $random_string=&generate_random_string(32); 
    push(@array, $random_string );

  }
  print $_ . "" . $random_string . "\n";
  warn qx{ ps -o rss,vsz $$ }, "\n";
  #print 'memory: '. &memory_usage() ."\n";
}

#--------------------------------------------------------------#
