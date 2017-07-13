#!/usr/bin/perl

my $directory = '/run/shm';
opendir (DIR, $directory) or die $!;

while (my $file = readdir(DIR)) {
  
  if($file =~ /\.html/) {
        my $filename = '/run/shm/' . $file;
        my $filesize = -s $filename;
  	print $filesize . "\t" . $filename . "\n";
        if( $filesize > 1048576 ) {
            unlink $filename;
        }
  }
}

