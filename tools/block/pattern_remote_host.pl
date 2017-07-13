#!/usr/bin/perl
use strict;
use warnings;

#--------------------------------------------------------------#
# Block remote host based on "site:" search pattern
#--------------------------------------------------------------#
use Time::HiRes qw(usleep sleep);
my @array;
my $str;
my %hash;
my $flag=0;

open(FILE, "<", "/var/log/apache2/search.log");

while(<FILE>) {

   if($_ =~ /site:/) {
        @array = split(/\s+/, $_);
        print $_;
        $hash{$array[1]}++;
        $flag++;                                                                                                         
   }
}
close(FILE);

if($flag > 0) {
	my $res = `echo > /var/log/apache2/search.log`;

	foreach my $key ( keys(%hash) )                                                                             
	{
                $str = "iptables -I INPUT -s $key -j DROP";
   		print $str . "\n";                                                                          
   		my $res = `$str`;        
	}
}
#--------------------------------------------------------------#

