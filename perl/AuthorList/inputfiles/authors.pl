#! /opt/star/bin/perl -w

use File::Basename;
use Getopt::Std;
use Cwd 'abs_path';
use diagnostics;

#my $key = "key";
#my $author = "author";
#if (-e $key) { print "$key exist !\n"; }
#if (-e $author) { print "$author exist !\n"; }
#print "\n";


open input_keys,"<","input_keys" or die "can't open file: $!";
my %hash;
my @keys;
my $number = 0;

while(<input_keys>){
	chomp $_;
	# print " $_ \n";
	my @rawkeys = split(/\}/,$_);
	#print "$rawkeys[$#rawkeys] \n";
	@keys = split(/\{/,$rawkeys[$#rawkeys]);
	print "$keys[$#keys] \n";
	chomp $keys[$#keys];

    $number = $number + 1;
	chomp $number;
	print "$number \n";

	$hash{$keys[$#keys]} = $number; 
}


open input_authors,"<","input_authors" or die "can't open file: $!";
open $output_authors,">","output_authors.txt";
my @rawauthors;
my @IndexKey;
my @authors;
my @myauthors;

select $output_authors;
print "\\author{" ;

my $nlines = 0;
while(<input_authors>){
	chomp;
	@rawauthors = split(/\}/,$_);
	chomp $rawauthors[1];
#	print $rawauthors[1] ;
#	print "\n" ;
	@IndexKey = split(/\{/,$rawauthors[1]);
#	print "$IndexKey[$#IndexKey] \n" ;
	@authors = split(/\\/,$rawauthors[0]);
#	print $authors[1];
#	print "\n" ;
	@myauthors = split(/\{/,$authors[1]);
#	print $myauthors[1];
#	print "\n" ;

	select $output_authors;
    $myIndex = $IndexKey[$#IndexKey];
	my $myxxx = $hash{$myIndex} ;
    $myauthors[1] .= "\$^{" ;
	print "$myauthors[1]";
	print $hash{"$myIndex"};
	print "}\$, ";
	$nlines = $nlines +1;
	if($nlines%3 eq 0) { print "\n" ; }
}

print "\n";
print "\\\\ \n";

open config,"<","input_keys" or die "can't open file: $!";
my $count = 0;
my @keysOut;
while(<config>){
	select $output_authors;
	chomp $_;
# print " $_ \n";
	my @rawkeysOut = split(/\}/,$_);
#print "$rawkeysOut[$#rawkeysOut] \n";
	@keysOut = split(/\{/,$rawkeysOut[$#rawkeysOut]);
	print "\\normalsize{\$^{";
	$count = $count + 1;
	chomp $count;
	print "$count";
	print "}\$";
	print "$keysOut[$#keysOut]";
	chomp $keysOut[$#keysOut];

	print "}\\\\ \n";
}

print "}";
