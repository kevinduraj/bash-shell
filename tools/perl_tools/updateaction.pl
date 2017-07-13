#!/usr/bin/perl
use DBI;
use strict;
use warnings;
#----------------------------------------------------------------------------------#
my $site   = $ARGV[0];
my $action = $ARGV[1];

$site =~ tr/A-Z/a-z/;
&update_action($site, $action);
&check_rank($site);


#-----------------------------------------------------------------------------------#
sub update_action
{
  my ($site, $action) = @_;
  my $dbh = DBI->connect( 'DBI:mysql:mysql_socket=/var/lib/mysql/mysql.sock;database=engine1'
                        , 'root', 'xapian64');

  #$site   = '%.' . $site;
  $site   = $dbh->quote($site);
  $action = $dbh->quote($action);

  my $sql = qq/UPDATE engine1.trafficrank SET action=$action WHERE domain LIKE $site;/;

  #print $sql . "\n";
  $dbh->do( $sql );
  $dbh->disconnect();

}
#-----------------------------------------------------------------------------------#
sub check_rank
{
  my $site  = shift;
  my $exist = "no";
  my $dbh   = DBI->connect( 'DBI:mysql:mysql_socket=/var/lib/mysql/mysql.sock;database=engine1'
                          , 'root', 'xapian64');

  $site   = $dbh->quote($site);
  my $sql = qq/select domain, action, rank from engine1.trafficrank where domain=$site/;

  my $sth = $dbh->prepare($sql);
  $sth->execute();

  if ($sth->rows > 0) 
  { 
    $exist="yes"; 
    my $ref = $sth->fetchrow_hashref();
    print "--------------------------------------------------------------------\n";
    print "Domain: $ref->{'domain'}=$ref->{'rank'}\taction=$ref->{'action'}\n"; 
    print "--------------------------------------------------------------------\n";
  }
  
  $sth->finish();
  $dbh->disconnect();
  return $exist;
}
#-----------------------------------------------------------------------------------#

