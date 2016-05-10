#!/usr/bin/perl
use strict;
use POSIX qw( strftime );
$| = 1;

#----------------------------------------------------------------------------------------------------------#
# Transform users 
#----------------------------------------------------------------------------------------------------------#
sub transform_users {

  print "1. Transforming users.csv please wait ...\n";

  my $filename = 'users.csv';
  open(my $input, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
  open(my $output, '>', 'users.transformed.tmp');
  while (my $row = <$input>) {

    chomp $row;
    $row =~ s/\"//g;

    my @array = split(',', $row);
    my $formatted = strftime("%Y-%m-%d %H:%M:%S", localtime($array[2]/1000000));
    my $line = sprintf "%s %85s %20s\n", $formatted, $array[0], $array[1];

    print $output $line;

  }

  close $output;
  close $input;

}

#----------------------------------------------------------------------------------------------------------#
# Transform Events
#----------------------------------------------------------------------------------------------------------#
sub transform_events {

  print "2. Transforming events.csv please wait ...\n";

  my $filename = 'events.csv';
  open(my $input, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
  open(my $output, '>', 'events.transformed.tmp');

  my $count=1;
  while (my $row = <$input>) {

    chomp $row;
    $row =~ s/\"//g;

    my @array = split(',', $row);
    my $formatted = strftime("%Y-%m-%d %H:%M:%S", localtime($array[5]/1000));
    my $line = sprintf "%s %15s %4s %83s %23s\n", $formatted, $array[4], $array[0], $array[2], $array[1];

    print $output $line;
    print $count . " " . $formatted . " " .  $array[4] . " " . $array[1] . "\n" if ($count % 100000) == 0; $count++;
  }
  
  close $output;
  close $input;
}

#----------------------------------------------------------------------------------------------------------#



transform_users();
transform_events();
