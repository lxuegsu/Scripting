
#! /usr/bin/perl -w

use Time::localtime;
use File::stat;

my @files;
my @runnumbers;
my @rundays;

# read in configurations

open (configFile, "< /ldaphome/aihong/HLTMonitorScripts/hltMonitor.config") or die "can't open config file \n";
  while (<configFile>){
       chomp;                          # no newline
       s/#.*//;                        # no comments
       s/^\s+//;                       # no leading white
       s/\s+$//;                       # no trailing white
       next unless length;             # anything left?
       my ($var, $value) = split (/\s*:\s*/, $_,2);
       $ConfigMap{$var} = $value;
     }
close(configFile);

exit;
