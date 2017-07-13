#!/usr/bin/perl
use strict;

srand($$);

my $text = &random_text();
print $text . "\n";

sub random_text {
    my $text;
    my @alphanum = ( 'A' .. 'Z', 'a' .. 'z', 0 .. 9 );
    for ( map( $alphanum[ rand($#alphanum) ], ( 1 .. 10 ) ) ) { $text .= $_; }
    return $text;
}
