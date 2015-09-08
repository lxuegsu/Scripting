#!/usr/bin/perl -w
use File::Basename;
use diagnostics;

open RUN, "> list" ;

open CONFIG,"<","He3FilesList" or die "can't open file: $!";

while(<CONFIG>){
	chomp;
	select RUN ;
	my $dir = File::Basename::dirname($_);
	my $file = File::Basename::basename($_);
	print "$file\n" ;
}

