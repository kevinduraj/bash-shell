#!/usr/bin/perl -w 
#------------------------------------------------------------------------------#

my $text = qq/One thow three four five six seven eight nine ten eleven./;

&compute_spamdex($text);

#------------------------------------------------------------------------------#
sub compute_spamdex
{
  my $text   = shift; 
  my @array  = split(/ /, $text);
  my %hash   = ();
  my($key, $value );
  my($total_key, $total_value, $spamdex, $sig) = (0,0,0);

  foreach(@array)
  {
    $total_value ++;
    $hash{$_} += 1;
  }

  #while (($key, $value) = each(%hash))
  #{
  #  print "Key:".$key."\t" if $DEBUG;
  #  print "Value:".$value."\n" if $DEBUG;
  #  $total_key++;
  #}

  foreach $key (sort { $hash{$a} <=> $hash{$b} } keys %hash)
  {
    #-- print $key . ":" . $hash{$key} . "\n";
    $total_key++;
    $sig = $hash{$key};
  }

  print "Significance=" . $sig         . "\n" if $DEBUG;
  print "Terms="        . $total_key   . "\n" if $DEBUG;
  print "Total Value:"  . $total_value . "\n" if $DEBUG;

  $spamdex = $total_value / $total_key if(($total_value) && ($total_key));
  printf("Spamdex: %0.2f", $spamdex) if $DEBUG;

  $total_key = 0 unless $total_key;
  $sig       = 0 unless $sig;

  print "spamdex  = $spamdex\n";
  print "terms    = $total_key\n";
  print "sig      = $sig\n";

  my $ratio       = ($sig/ $total_key ) * 100;
  print "ratio    = $ratio\n";

}
#------------------------------------------------------------------------------#

