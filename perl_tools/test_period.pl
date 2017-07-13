#!/usr/bin/perl 
use strict;
use warnings;
use Parser; 
use Data::Dumper;
#------------------------------------------------------------------------------#

my $parser = Parser->new();

$parser->init_special_formatter();
$parser->make_period();

print $parser->{period} . "\n";

#------------------------------------------------------------------------------#
