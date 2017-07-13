#!/usr/bin/env perl
# Convert Data File into BerkeleyDB Hash
# http://search.cpan.org/~pmqs/BerkeleyDB-0.39/BerkeleyDB.pod
#------------------------------------------------------------------------------#
use strict;
use warnings;
my $url;
my $end;

my $str = 'http://rd.nicovideo.jp/cc/header/chokuhan">ニコニコ直販</a>';

            #--- Clean URLs ---#
            #my $pos = index( $_, 'http' );
            #my $url = substr( $_, $pos );
            #$url =~ s/\s+//g;

            #--- Clean badly formatter URLs
            $end = index($str, '</a>') - 1;
            if ($end > 0) { $url = substr($str, 0, $end); }
            else { $end = index($str, '"') - 1; }
            if ($end > 0) { $url = substr($str, 0, $end); }
            else { $url = $str; }

print $url . "\n";
#------------------------------------------------------------------------------#
__END__

