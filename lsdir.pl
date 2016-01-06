#!/usr/bin/perl
$|++;
foreach (<*>){
    print "$_\n" if -d;
} exit 0;
