#!/usr/bin/perl
use strict;
use warnings;

use Time::HiRes qw(usleep sleep);
my @array;
my @ips;
my $ip;

my $str;
my %hash;
my $flag = 0;

open(FILE, "<", "/var/log/apache2/search.log");

while (<FILE>)
{

    if ($_ =~ /site:/)
    {
        @array = split(/\s+/, $_);
        print $_;
        @ips = split(/\./, $array[1]);
        $ip = $ips[0] . '.' . $ips[1];
        $hash{$ip}++;
        $flag++;
    }
}
close(FILE);

if ($flag > 0)
{
    my $res = `echo > /var/log/apache2/search.log`;

    foreach my $key (keys(%hash))
    {
        $str =
          "iptables -I INPUT -m iprange --src-range $key.0.0-$key.255.255 -j DROP";
        print $str . "\n";
        my $res = `$str`;
        sleep 0.5;
    }
}

