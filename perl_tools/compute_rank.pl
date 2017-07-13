#!/usr/bin/perl
use strict;
use warnings;

my $x = 0;
my $i = 300;
for ( $x = 0; $x < 1_000_000; $x += 3_333 ) {

    print $i . "\t" . $x . "\n";
    $i--;
}
print "-----------------------------------------\n";

my $a = 580036;
my $s = int( 300 - ( $a / 3_333 ) );

print $a . "=" . $s . "\n";

