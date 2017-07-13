#!/usr/bin/perl -w


for(0..32)
{
  my $x = $_;

  my $fog = exp($x/7);

  print $fog . "\n";
  
}
   
