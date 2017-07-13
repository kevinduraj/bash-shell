#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use Time::HiRes qw( gettimeofday tv_interval );
use vars qw( $dbh $sth %hash);
$| = 1;
#----------------------------------------------------------------------------------#
$dbh = DBI->connect('DBI:mysql:mysql_socket=/var/run/mysqld/mysqld.sock',
                    'root', 'xapian64', {RaiseError => 1, AutoCommit => 0})
  || die "Database connection not made: $DBI::errstr";

#----------------------------------------------------------------------------------#
$sth  = $dbh->prepare("SELECT terms FROM engine3.keywords_health;");
$sth->execute();
#----------------------------------------------------------------------------------#
while ( my $ref = $sth->fetchrow_hashref() ) 
{
    my @array = split(/ /, $$ref{terms});
    foreach my $term (@array) {

       if(length($term) < 4) { } 
       elsif($term =~ /\b(system|kevin)\b/) { }
       else { $hash{$term}++; }

    }
}
#----------------------------------------------------------------------------------#
#foreach my $k ( keys(%hash) )                                                                             
foreach my $k (sort { $hash{$a} <=> $hash{$b} } keys %hash) 
{                                                                                                         
   print "$k : $hash{$k}\n";                                                                              
} 
#----------------------------------------------------------------------------------#

