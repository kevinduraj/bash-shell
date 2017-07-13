#!/usr/bin/perl -w
use strict;


my $text = qq/
Attached is my product specification. My intent with this spec was to capture what Steve B. had in mind. Some of the ideas might need to be baked further and some might not make sense so it is open for adjustments. Also, the metrics for success have been difficult. The only thing that we have available is a spreadsheet (attached) that Steve uses to measure the number of canned responses used to answer emails. There is one that deals with abuse that we could measure. This has gone down dramatically since the IM permissions project went live. The screenshot below shows the total number of profiles processed along with a column telling us the number of profiles rejected, which I think we can figure out what the reason was for. It may be that we need to put some more precise metrics in place to be able to measure the success of this project.
/;

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
  foreach $key (sort { $hash{$a} <=> $hash{$b} } keys %hash)   
  {
    print $key . ":\t" . $hash{$key} . "\n";  
  }

