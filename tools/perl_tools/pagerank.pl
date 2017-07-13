#!/usr/bin/perl
use DBI;
use strict;
use warnings;
#--------------------------------------------------------------------------------------------------#
my $domain        = $ARGV[0];
my $type1         = $ARGV[1] || 0;
my $rank          = $ARGV[2] || 0;
my $traffic_table = undef;
#--------------------------------------------------------------------------------------------------#

  $domain =~ tr/A-Z/a-z/;

  print $domain . "=";
  my @pagerank = `lynx -dump http://www.alexa.com/siteinfo/$domain`;
  my $alexa    = &retrieve_rank(\@pagerank);

  print $alexa . "\n";
  my $robots = `/usr/bin/curl \"http://www.$domain/robots.txt\" -s -j --connect-timeout 3 --max-time 5 -e myhealthcare.com`;
  &insert_rank_type1($domain, $alexa, $rank, $type1, $robots);
  &check_rank($domain);

#--------------------------------------------------------------------------------------------------#
sub get_random_domain
{
  my $dbh   = DBI->connect( 'DBI:mysql:mysql_socket=/var/run/mysqld/mysqld.sock;database=engine1'
                          , 'root', 'xapian64');

  my $sql = "SELECT CONCAT('engine1.traffic_',substr(sha1(RAND()), 1, 2)) as TRAFFIC;";
  my $sth = $dbh->prepare($sql);
  $sth->execute();
  my $ref = $sth->fetchrow_hashref();
  $traffic_table = $ref->{'TRAFFIC'};

  $sql = qq/SELECT domain FROM $traffic_table WHERE type1 > 0 AND rank < 2000000 ORDER BY RAND() LIMIT 1;/;
  $sth = $dbh->prepare($sql);
  $sth->execute();
  $ref = $sth->fetchrow_hashref();

  print "Checking Domain: $ref->{'domain'}\n";

  $domain = $ref->{'domain'};

  $sth->finish();
  $dbh->disconnect();

}
#--------------------------------------------------------------------------------------------------#
sub refresh_robots_only
{
  my ($domain, $robots) = @_;
  my $dbh = DBI->connect( 'DBI:mysql:mysql_socket=/var/run/mysqld/mysqld.sock;database=engine1'
                        , 'root', 'xapian64');

  $domain = $dbh->quote($domain);
  $robots = $dbh->quote($robots);

  my $sql;
  $sql = qq/UPDATE $traffic_table SET robots = $robots WHERE domain LIKE $domain; /;

  print $sql . "\n";
  $dbh->do( $sql );
  $dbh->disconnect();

}
#--------------------------------------------------------------------------------------------------#
sub refresh_rank_only
{
  my ($domain, $alexa, $rank, $type1, $robots) = @_;
  my $dbh = DBI->connect( 'DBI:mysql:mysql_socket=/var/run/mysqld/mysqld.sock;database=engine1'
                        , 'root', 'xapian64');

  $domain = $dbh->quote($domain);
  $alexa  = $dbh->quote($alexa);
  $rank   = $dbh->quote($rank);
  $robots = $dbh->quote($robots);

  my $sql;
  if($type1 > 1)
  {
    $sql = qq/
       INSERT INTO engine1.traffic (domain, alexa, robots, dt)
       VALUES ( $domain,  $alexa, $robots, now()) ON DUPLICATE KEY UPDATE 
       alexa=VALUES(alexa), robots=VALUES(robots), counter=counter+1, dt=VALUES(dt); /;
  }
  else
  {
    $sql = qq/
       INSERT INTO engine1.traffic (domain, alexa, rank, robots, dt)
       VALUES ( $domain,  $alexa, $rank, $robots, now()) ON DUPLICATE KEY UPDATE 
       alexa=VALUES(alexa), rank=VALUES(rank), robots=VALUES(robots), counter=counter+1, dt=VALUES(dt); /;

  }

  #print $sql . "\n";
  $dbh->do( $sql );
  $dbh->disconnect();

}
#--------------------------------------------------------------------------------------------------#
#                                  Insert Rank Into Cluster
#--------------------------------------------------------------------------------------------------#
sub insert_rank_type1
{
  my ($domain, $alexa, $rank, $type1, $robots) = @_;
  if($rank == 0) { $rank = $alexa; }
  my $dbh = DBI->connect( 'DBI:mysql:mysql_socket=/var/run/mysqld/mysqld.sock;database=engine1'
                        , 'root', 'xapian64');

  #------------------- Create Cluster -----------------------#
  my $temp  = $dbh->quote($domain);
  my $sth   = $dbh->prepare( "SELECT sha1($temp);" );
  $sth->execute( );
  my $row   = $sth->fetchrow_array();
  my $root  = $row;
  $traffic_table = "engine1.traffic_" . substr($root , 0, 2);
  #----------------------------------------------------------#

  $root   = $dbh->quote($root);
  $domain = $dbh->quote($domain);
  $alexa  = $dbh->quote($alexa);
  $rank   = $dbh->quote($rank);
  $robots = $dbh->quote($robots);
  
  my $sql = qq/
     INSERT INTO $traffic_table (domain, alexa, rank, type1, robots, dt)
       VALUES ( $domain,  $alexa, $rank, $type1, $robots, now()) ON DUPLICATE KEY UPDATE 
          alexa=VALUES(alexa), rank=VALUES(rank), type1=VALUES(type1), 
          robots=VALUES(robots), counter=counter+1, dt=VALUES(dt); /;

  #print $sql . "\n\n\n\n";
  $dbh->do( $sql );

  $sth->finish; 
  $dbh->disconnect;

}
#--------------------------------------------------------------------------------------------------#
sub check_rank
{
  my $domain  = shift;
  my $exist = "no";
  my $dbh   = DBI->connect( 'DBI:mysql:mysql_socket=/var/run/mysqld/mysqld.sock;database=engine1'
                          , 'root', 'xapian64');

  $domain = $dbh->quote($domain);
  my $sql = qq/select * from $traffic_table where domain=$domain/;
  my $sth = $dbh->prepare($sql);
  $sth->execute();

  if ($sth->rows > 0)
  {
    $exist="yes";
    my $ref = $sth->fetchrow_hashref();
    print "------------------------------------------------------------------------------------\n";
    print "$traffic_table Domain: $ref->{'domain'}=$ref->{'alexa'}|$ref->{'rank'} type1=$ref->{'type1'} dt=$ref->{'dt'}\n";
    print "------------------------------------------------------------------------------------\n";
  }
 
  $sth->finish;
  $dbh->disconnect;
 
  return $exist;
}
#--------------------------------------------------------------------------------------------------#
sub retrieve_rank
{
  my $arr_ref = shift;

  foreach my $line (@$arr_ref)
  {
    if($line =~ /Global No data/) 
    {  
      $line = 9000000; 
    }
    elsif($line =~ /Global/)
    {
       $line =~ s/Global //;
       $line =~ s/\,//g;       
       $line =~ s/^\s+//;
       $line =~ s/\s+$//;
       print $line . "\n";
       return $line;
    }
  }
  return 9000000;
}
#--------------------------------------------------------------------------------------------------#
