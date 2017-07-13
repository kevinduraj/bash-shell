#!/usr/bin/perl
use strict;
use warnings;
use URI::URL;
#------------------------------------------------------------------------------#

  my $url    = shift;
  my $domain = URI->new( $url );
  my $temp   = $domain->host;
  $temp      =~ s!^(www\.)?!!i;
  #$self->{root} = $temp;
  my(@a) = split(/\./, $temp);

  my(@b, $out);
  my $size = scalar(@a);
  if(length($a[$size-1]) != 2)
  {
    @b = splice(@a, $size-2, $size+1);
    $out = join(".",@b);
    #for(@b) { print $_ . "\n"; }
  }
  else 
  { 
    @b = splice(@a, $size-3, $size+1);
    $out = join(".",@b); 
  }
  print $out;
  
#------------------------------------------------------------------------------#
