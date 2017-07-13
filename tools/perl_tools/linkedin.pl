#!/usr/bin/perl

print "Hello\n";

$url   = 'http://www.in.linkedin.com/pub/taraka-nagendra/17/428/b06';
$pos = index($url, 'linkedin');
$url   = "http://www." . substr($url, $pos);

print $url;


