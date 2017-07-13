#!/usr/bin/perl 
use strict;
use warnings;
use Time::HiRes qw(sleep);
$|++;
my $dir = "/data1/logs";

my $counter = 0;
open( FILE, "<", "$dir/all_data.log" ) or die "Can't open file: $!";
open( OUT,  ">", "$dir/new_data.log" ) or die "Can't open file: $!";
while (<FILE>) {
    $counter++;
    my $url = $_;

    if ($url) {
        if ($url !~ /
\.info|cnn\.com|go\.com|wired\.com|thebrandeishoot\.com|theverge\.com|latimes\.com|forbes\.com|contactmusic\.com
|scotsman\.com|chrisroubis\.com|in\.com|co\.za|greenfieldreporter\.com|msn\.com
|therepublic\.com|newsecuritybeat\.org|marketplayground\.com|nj\.com|stltoday\.com|nytimes\.com|washingtonpost\.com
|newsvine\.com|dailyjournal\.net|facebook\.com|nextbigfuture\.com|webmd\.com|medicalxpress\.com|lainformacion\.com
|typepad\.com|wordpress\.com|twitter\.com|bizjournals\.com|com\.au|cbslocal\.com|zap2it\.com|huffingtonpost\.com|wickedlocal\.com|co\.uk
                    /ix)
        {

            print $url if ( ( $counter % 10000 ) == 0 );
            print OUT $url;
        }
    }
}

close(FILE);
close(OUT);

__END__

