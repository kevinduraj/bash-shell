#!/usr/bin/perl
use strict;
use warnings;
use v5.14;
use utf8;
$|++;
print "Perl Version $^V\n";
#------------------------------------------------------------------------------#
use YAML::Tiny;
my $yaml = YAML::Tiny->new;
$yaml = YAML::Tiny->read('config.yml');
#------------------------------------------------------------------------------#
use vars qw( $task %bad_domains $file %opts @prod );
my $file = __FILE__;
my $PROCESS = substr( $file, 2 );

#------------------------------------------------------------------------------#
use BerkeleyDB;
use DateTime;
use DBI;
use Fcntl qw(:flock);
use File::Slurp;
use Getopt::Long;
use HTML::LinkExtractor;
use LWP::Simple qw(get);
use LWP::UserAgent;
use SpiderModel;
use Time::HiRes qw(usleep sleep);
#------------------------------------------------------------------------------#
my $start_time = [ Time::HiRes::gettimeofday() ];
my $filename   = "/dev/shm/" . $$ . ".html";
my %links_hash = ();
my $LX         = new HTML::LinkExtractor();
my $content;
#-----------------------------------------------------------------------------------------#
open( FILE, "3_bad_domains.txt" ) or die "$!";
while (<FILE>) {
    chomp($_);
    my ($domain) = $_;
    $bad_domains{$domain} = 1;
}
close(FILE);

#-----------------------------------------------------------------------------------------#
#   Menu Options
#-----------------------------------------------------------------------------------------#
my @getopt_args = ( 'task=s', 'url=s', 'd', 'h' );
my $menu = <<EOT;
Usage:  [-options] 
  -task    Task Number
  -url     Force url 
  -h       Help Menu 

EOT

GetOptions( \%opts, @getopt_args );
if   ( $opts{task} ) { $task = $opts{task}; }
else                 { $task = 0; }

our $DEBUG = 0;
if ( $opts{d} ) { $DEBUG = 1; }

#-----------------------------------------------------------------------------------------#
tie @prod, 'BerkeleyDB::Recno',
    -Filename => $yaml->[$task]->{berkeley},
    -Flags    => 'DB_RDONLY',
    -Property => 'DB_RENUMBER'
    or die "Cannot open $yaml->[$task]->{berkeley} : $!\n";

our $LAST_DOCS = @prod;
print "total size=" . $LAST_DOCS . "\n";

#-----------------------------------------------------------------------------------------#
my $model = eval { new SpiderModel( $task, $yaml ); } or die($@);
$model->{dbh} = DBI->connect( 'DBI:mysql:mysql_socket=/var/run/mysqld/mysqld.sock', 'root', 'xapian64' ) or exit;
$model->{dbh}->do("set names 'utf8';");
$model->init_domains();

#------------------------------------------------------------------------------------------#
limit_memory();
limit_process();

my $counter = 0;
START:

$counter++;
my $diff = Time::HiRes::tv_interval($start_time);

if ( $diff > $yaml->[$task]->{maxtime} ) {
    print "Time out, exiting ... ";
    $model->disconnect;
    exit;
}

&start();

#------------------------------------------------------------------------------------------#
#                                  Start Spider                                            #
#------------------------------------------------------------------------------------------#
sub start {
    $model->initialize();

    print "\n************* [ Round=$counter | INDEX= $yaml->[$task]->{berkeley} **************\n";
    if ( $opts{d} ) { sleep 0.5; }
    if ( $opts{url} ) {
        $model->{url} = $opts{url};
        $model->make_sha();
    }
    else { &get_next_url(); }

    if ( length( $model->{url} ) < 11 ) { goto START; }

    &get_domain();

    if ( $bad_domains{ $model->{root} } ) {
        print 'Banned Domain: ' . $model->{root} . "\n";
        goto START;
    }
    elsif ( $model->{root} =~ /(\.ru|\.pl|\.ro)$/x ) {
        print 'Banned Domain: ' . $model->{root} . "\n";
        goto START;
    }    # exclude Russia, Poland, Romania

    if ( ( $model->{title} eq "badurl" ) || ( !$model->{url} ) ) { goto START; }
    $model->get_curl();
    #$model->get_lwp();
    $model->parse_general();

    if ( ( !$model->{body} ) || ( length( $model->{body} ) < 8 ) ) {
        goto START;
    }

    $model->make_period();

    $model->natural_language_processing();
    if ( ( $model->{title} eq "badurl" ) || ( !$model->{url} ) ) { goto START; }
    $model->compute_spamdex($DEBUG);

    #------------------------ Extract links from HTML file -----------------------#
    %links_hash = ();
    $content = read_file($filename);
    $LX->parse( \$content );
    #$LX->parse( \$model->{raw} );
    foreach my $link ( @{ $LX->links } ) {

        if ( exists $link->{href} ) {
            if (( $link->{href} =~ /^http:\/\// ) && 
                ( $link->{href} !~ /(\?|\#|google|css|shop|jpg|
                                     lawyer|rss|session|yahoo)/ix)) 
            {
                $links_hash{ $link->{href} } = 1;
            }
        }
    }
    open( FILE, '>>', "$yaml->[$task]->{newlinks}" ) or die "$! $yaml->[$task]->{newlinks}" ;
    foreach my $key ( keys(%links_hash) ) { print FILE $key . "\n"; } close(FILE);
    #------------------------ End of extracting URL links ------------------------#


    unlink($filename);

    if   ( length( $model->{body} ) > 16 ) { $model->insert_website($DEBUG); }
    else                                   { print "body too short ..."; }
    if ( $opts{url} ) { exit; }

    goto START;
}

#--------------------------------------------------------------------------------------------#
sub get_next_number {
    my $SEMAPHORE = $yaml->[$task]->{sequence} . ".lock";

    open( LOCK, ">$SEMAPHORE" ) or die "Can't open $SEMAPHORE ($!)";
    flock( LOCK, LOCK_EX );

    open( DATA, $yaml->[$task]->{sequence} ) or die "Can't open $yaml->[$task]->{sequence} ($!)";
    my $count = <DATA>;
    close DATA;

    $count++;
    print "sequence=$count\n";

    open( DATA, "+< $yaml->[$task]->{sequence}" ) or die "Can't open $yaml->[$task]->{sequence} ($!)";
    print DATA $count;
    close DATA;
    close LOCK;

    return $count;

}

#---------------------------------------------------------------------------------------------#
sub limit_memory {

    # ps -aylC perl | grep perl | awk '{ print $8 " " $3 }' | sort -n | tail -1
    my ( $size, $proc ) = split( ' ', `ps -aylC $PROCESS | grep $PROCESS | awk '{ print \$8 " " \$3 }' | sort -n | tail -1`);
    chomp($proc);
    print "Process ID = " . $$ . "\n";
    print "script=" . $PROCESS . " proc=" . $proc . " size=" . $size . "\n";

    if ( $size > 100000 ) {
        print "---- Too Much Memory Allocation ---\n";
        print "kill -9 $proc\n";
        my $res = `kill -9 $proc`;
        sleep 1;
        exit;
    }
}

#------------------------------------------------------------------------------------------#
sub killprocess {

    my ( $size, $proc ) = split( ' ', `ps -aylC $PROCESS | grep $PROCESS | awk '{ print \$8 " " \$3 }' | sort -n | tail -1`);
    chomp($proc);
    print "Process ID = " . $$ . "\n";
    print "script=" . $PROCESS . " proc=" . $proc . " size=" . $size . "\n";

    print "kill -9 $proc\n";
    my $res = `kill -9 $proc`;
    sleep 1;
}

#--------------------------------------------------------------------------------------------#
sub limit_process {
    my $uptime = `uptime`;
    my $start  = index( $uptime, "load average:" ) + 14;
    my $line   = substr( $uptime, $start );
    my @digits = split( /,/, $line );
    my $usage  = int( $digits[0] );

    if ( int($usage) > $yaml->[$task]->{maxcpu} ) {
        print "!!! $yaml->[$task]->{maxcpu} = $usage usage HIGH !!!\n";
        killprocess();
        exit;
    }
    else {
        print "CPU: MAX=$yaml->[$task]->{maxcpu} - ACTUAL=$usage - CPU usage is low\n";

        my $qty = `pgrep $PROCESS | wc -l`;
        print "Total Processes: " . $qty . "\n";

        if ( $qty > $yaml->[$task]->{maxproc} ) {
            print "Too many processes: $qty\n";
            exit;
        }
    }
}

#-------------------------------------------------------------------------------#
# Next Url from Database
#-------------------------------------------------------------------------------#
sub get_next_url {

    do {
        $model->{title} = "Title"; 
        my $doc_num = &get_next_number();

        if ( $prod[$doc_num] ) {
            ( $model->{url}, $model->{value} ) = split( /\|/, $prod[$doc_num] );
        }
        else { print "No more urls\n"; exit; }

        #----------------------------------------------------------------------------#
        if( $model->{url} =~ /(\.m3u|\.rar|\.mp3|\.mp4|\.avi|\.rm|\.css|\.exe|\.jpg|
                              \.png|\.gif|\.pdf|\.ico|\.gz|\.zip|\.xml|\.cfm)$/ix )  
        { print "Bad END of URL: " . $1 . ' -> ' . $model->{url} . "\n";
           $model->{title} = "badurl";
        }
        #----------------------------------------------------------------------------#
        if( ($model->{url} =~ /(\.ly\/|\.ru\/|\.pt\/|rss|
                               google|sport|milit|weather|advert|realestate|
                               torrent|download|upload|search|click)/ix)  
         && ($model->{url} !~ /research/) )
        {   
            
            print "Bad IN TEXT URL: " . $1 . ' -> ' . $model->{url} . "\n";
            $model->{title} = "badurl";
        }
        #----------------------------------------------------------------------------#

    } while ( $model->{title} eq "badurl" );

    $model->make_sha();
}

#------------------------------------------------------------------------------o
sub get_domain {
    my $root;
    my $url = $model->{url};

    eval {
        $url =~ s!^(http://|https://)!!;
        my $len = length($url);
        my $pos = index( $url, "/" );

        if ( $pos > 0 ) {
            my $domain = substr( $url, 0, $pos );
            $root = $model->{suffix}->get_root_domain($domain);
        }
        else {
            $root = $model->{suffix}->get_root_domain($url);
        }
    };
    if ($@) { goto START; }

    if ($root) { $model->{root} = lc $root; }
    else       { goto START; }
    $model->do_md5root();
}

#------------------------------------------------------------------------------#
__END__

#srand( time ^ $$ ^ unpack "%L*", `ps axww | gzip -f` );
#if ( !$opts{d} ) {
#    my $slp = int( rand(45) );
#    print "Sleeping=" . $slp . "\n";
#    sleep $slp;
#}
#my $file = __FILE__;
#my $script = substr( $file, 2 );
#------------------------------------------------------------------------------#
