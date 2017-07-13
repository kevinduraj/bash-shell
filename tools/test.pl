#!/usr/bin/perl
use strict;
use warnings;
use Proc::Daemon;
use Time::HiRes qw(usleep sleep);
use DateTime::Functions;
#--------------------------------------------------------------------------------------------------#
# It monitors remote access acivities
#--------------------------------------------------------------------------------------------------#
my $REGEX = qr/(site:|scott\+burns)/;

my $LOGFILE='/var/log/apache2/redirect.log';

Proc::Daemon::Init;
my $continue = 1;
$SIG{TERM} = sub { $continue = 0 };

#--------------------------------------------------------------------------------------------------#
while ($continue)
{
    &clear_site_search();
    sleep 10;
    &cpu_high();
    sleep 10;
    &file_size();
    sleep 10;
}

#--------------------------------------------------------------------------------------------------#
#                                 Subroutines Called by Monitor
#--------------------------------------------------------------------------------------------------#
sub file_size
{
    my $directory = '/run/shm';
    opendir(DIR, $directory) or die $!;

    while (my $file = readdir(DIR))
    {

        if ($file =~ /\.html/)
        {
            my $filename = '/run/shm/' . $file;
            my $filesize = -s $filename;
            #print $filesize . "\t" . $filename . "\n";

            if ($filesize > 1048576)
            {
                unlink $filename;
            }
        }
    }
}
#-------------------------------------------------------------------------------------------------#
sub cpu_high
{
    my $res = `uptime | awk -F 'load average: ' '{print \$2}' | awk -F '.' '{print \$1}'`;

    if ($res > 5) { 
	#$res = system("killall -u spider"); 
        #&debug("CPU= $res killall -u spider");
        &debug("CPU= $res");
    }

    #if ($res > 8)
    #{
    #    $res = system("service apache2 restart"); 
    #    &debug("service apache2 restart");
    # 	sleep 10;
    #}
}

#----------------------------------------------------------------------------------------------------------------------------#
sub clear_site_search
{
    my @array; my @ips; my $ip; my $str; my %hash; my $flag = 0;

    open(FILE, "<", $LOGFILE);
    while (<FILE>)
    {

        if ($_ =~ $REGEX)
        {
            $flag++;
            @array = split(/\s+/, $_);
            $hash{$array[1]}++;
        }
    }
    close(FILE);

    if ($flag > 0)
    {

        foreach my $key (keys(%hash))
        {
            $str = "iptables -I INPUT -s $key -j DROP";
            my $res = `$str`;
            &debug($str);
        }

        my $res = `echo > $LOGFILE`;
    }

}

#----------------------------------------------------------------------------------------------------------------------------#
sub debug
{
  my $message = shift;
  open(DEBUG, ">>/root/debug.log");
  print DEBUG now->strftime("%Y-%m-%d %H:%M:%S") . "\t" .  $message . "\n";
  close(DEBUG);
}
#---------------------------------------------------------------------------------------------------------------------------#

