#!/usr/bin/env perl
# Convert Data File into BerkeleyDB Hash
# http://search.cpan.org/~pmqs/BerkeleyDB-0.39/BerkeleyDB.pod
#------------------------------------------------------------------------------#
use strict;
use warnings;
use BerkeleyDB;
use vars qw( %h $k $v $i $url $end $len);
$| = 1;

#------------------------------------------------------------------------------#
my $filename = "japan.log";
my $database = "hash_japan.bdb";

#------------------------------------------------------------------------------#
unlink($database);
tie %h, "BerkeleyDB::Hash",
  -Filename  => $database,
  -Flags     => DB_CREATE,
  -Cachesize => 4000000000,
  or die "Cannot open file $database: $! $BerkeleyDB::Error\n";

#------------------------------------------------------------------------------#

&load_data($filename);
print "Total=" . $i . "\n";
untie %h;

#------------------------------------------------------------------------------#
sub load_data
{
    my $sourcefile = shift;
    $i = 0;
    open(FILE, $sourcefile);

    while (<FILE>)
    {
        $len = length($_);
        next if $len > 255 || $len < 10;

        eval {
            chomp;

            #--- Clean badly formatter URLs
            $end = index($_, '"') - 1;
            if ($end > 0) { $url = substr($_, 0, $end); }
            else
            {
                $end = index($_, '<') - 1;
                if ($end > 0) { $url = substr($_, 0, $end); }
                else
                {
                    $end = index($_, '#') - 1;
                    if ($end > 0) { $url = substr($_, 0, $end); }
                    else          { $url = $_; }
                }
            }

            print "$i=$url\n" if (($i % 50000) == 0);
            $h{$url}++; $i++;
        };
        if ($@)
        {
            print $@ . "\n";
        }
    }

    close(FILE);
}

#------------------------------------------------------------------------------#
__END__

