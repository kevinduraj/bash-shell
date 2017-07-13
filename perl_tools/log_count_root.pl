#!/usr/bin/perl 
use strict;
use warnings;
use Time::HiRes qw(sleep);
use Domain::PublicSuffix;
$|++;

#------------------------------------------------------------------------------#
my $dir      = "/data1/logs";
my $suffix   = Domain::PublicSuffix->new();
my $hash_ref = {};

my $cnt = 0;
open( FILE, "<", "$dir/all_data.log" ) or die "Can't open file: $!";
while (<FILE>) {
    my ( $temp, $url ) = split( '//', $_ );

    $cnt++;
    my $root = get_root(\$_);
    print $cnt . '|' . $root . "|" . $url if ( ( $cnt % 100000 ) == 0 );
    $hash_ref->{$root}++;
    #last if $cnt > 1000;
}
close(FILE);

print_hashes($hash_ref);

#------------------------------------------------------------------------------#
sub print_hashes {
    my $hash_ref = shift;
    open( OUT, ">", "$dir/root_count.dat" ) or die "Can't open file: $!";
    for my $key1 ( keys %$hash_ref ) {
        print "$hash_ref->{$key1}|$key1\n";
        print OUT "$hash_ref->{$key1}|$key1\n";
    }
    close(OUT);
}

#------------------------------------------------------------------------------#
sub get_root {
    my $root = shift;

    $$root =~ s!^https?://(?:www\.)?!!i;
    $$root =~ s!/.*!!;
    $$root =~ s/[\?\#\:].*//;

    my @array = split( /\./, $$root );
    my $size = @array;

    if ( $size > 2 ) {
        my (@a) = splice( @array, $size - 2, $size - 1 );
        $$root = $a[0] . "." . $a[1];
    }
    chomp($$root);
    return $$root;
}

#------------------------------------------------------------------------------#

__END__

