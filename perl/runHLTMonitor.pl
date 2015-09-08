#! /usr/bin/perl -w

use Time::localtime;
use File::stat;
use FileHandle;


#$SIG{'USR1'} = 'wakeup';
$SIG{'USR1'} = \&wakeup;

sub wakeup;

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

my $logFile         = $ConfigMap{"logFile"};
my $sleepHours      = $ConfigMap{"sleepHours"};

# run loop

for (;;){

open (theLogFile, ">>$logFile");
theLogFile->autoflush(1);
print theLogFile "########### ".ctime()." : starting the procedure. \n";
close theLogfile;

system("perl ./hltMonitor.pl ");

open (theLogFile, ">>$logFile");
theLogFile->autoflush(1);
print theLogFile "########### ".ctime()." : finished updating the webpage. Now I am going to sleep ... \n";
close theLogfile;

sleep $sleepHours*3600;

}

# wake up signal handler

sub wakeup {
open (theLogFile, ">>$logFile");
theLogFile->autoflush(1);
print theLogFile "########### ".ctime()." : received kill -USR1, waking up ... \n";
close theLogFile;
exit0;
}

exit;
