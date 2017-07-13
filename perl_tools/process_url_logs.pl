#!/usr/bin/perl 
use strict;
use warnings;
use Time::HiRes qw(sleep);
$|++;
my $dir = "/data1/logs";

opendir( DIR, $dir );
my @FILES = readdir(DIR);

#--------------------------------------------------------------#
#                   Find Files
#--------------------------------------------------------------#
foreach my $file (@FILES) {

    if ( length($file) > 4 ) {
        print "OpenLogFile " . $file . "\n";
        process_file($file);
    }

}

#--------------------------------------------------------------#
sub process_file {
    my ($ff) = shift;
    my $counter=0;
    open( FILE, "<",  "$dir/$ff" )          or die "Can't open file: $!";
    open( OUT,  ">", "$dir/all_data.log" ) or die "Can't open file: $!";
    while (<FILE>) {
        $counter++;
        my ( $tmp, $url ) = split( 'http://', $_ );

        if ($url) {
            if (
                $url !~ /
                     google|\?|\#|\"|\.mp3|\.m3u|\.jpg|\.png|\.pdf|\.gif|\.rar]|\.ly\/|
                     href|localhost|yahoo|ebay|amazon|search|video|blog|answers\.com|
                     auction|archive\.org|queerty\.com|gay|india|china
                    /ix
              )
            {

                print 'http://' . $url if (($counter%25000)==0);
                print OUT 'http://' . $url;
            }
        }
    }

    close(FILE);
    close(OUT);
}

#--------------------------------------------------------------#

__END__

