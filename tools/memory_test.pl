#!/usr/bin/perl
system("ulimit -d 131072 -m 131072 -v 131072");

#$cool =  `ulimit -d 100000`;
#$cool = `ulimit -d 65536  -m 65536 -v 65536`;
#--------------------------------------------------------------#
#sub memory_usage 
#{
#  my $t = new Proc::ProcessTable;
#  foreach my $got ( @{$t->table} ) {
#    next if not $got->pid eq $$;
#    #if($got->size > 536870912) { exit; }
#    #else { return $got->size; }
#    return $got->size; 
#  }
#}
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

@array = ();
for(1..1000)
{
  for(1..10000)
  { 
    $random_string=&generate_random_string(32); 
    push(@array, $random_string );

  }
  print $_ . "" . $random_string . "\n";
  warn qx{ ps -o rss,vsz $$ }, "\n";
  #print 'memory: '. &memory_usage() ."\n";
}

#--------------------------------------------------------------#
