#!/usr/bin/perl


$string = "one two three four five agoura hills hello this is kevin duraj testing new search feature";
$find   = "kevin";

$pos = rindex($string, $find) - 40;
$zz = substr($string, $pos, length($string));

$zz =~ s/^\w+//;
$zz =~ s/^\s//;
print $zz . "\n";
