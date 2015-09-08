# this script does the following:
# 1. check if there is new produced data that has not been QAed
# 2. if there is, copy them to /star/institution disk, and produce .hist.root and .hist.pdf
# 3. update a webpage showing a table with pdf files produces, as well as the invariant mass plot.
# author : aihong tang. 5/18/2009


#! /usr/bin/perl -w

use Time::localtime;
use File::stat;
use FileHandle;

my @files;
my @runnumbers;
my @rundays;

sub parseFileName;
sub addDay139AndUp;

# read in configurations


open (configFile, "< /ldaphome/aihong/HLTMonitorScripts/hltMonitor.config");# or die "can't open config file \n";
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

my $sourcePath      = $ConfigMap{"sourcePath"};
my $targetPath      = $ConfigMap{"targetPath"};
my $logFile         = $ConfigMap{"logFile"};
my $plotsPath       = $ConfigMap{"plotsPath"};
my $plotsPathURL    = $ConfigMap{"plotsPathURL"};
my $commentFileName = $ConfigMap{"commentFileName"};
my $sleepHours      = $ConfigMap{"sleepHours"};
my $htmlFileName    = $ConfigMap{"htmlFileName"};
my $fileMinimumAge  = $ConfigMap{"fileMinimumAge"};
my $fileMinimumSize = $ConfigMap{"fileMinimumSize"};
my $forceReDoQAPlots= $ConfigMap{"forceReDoQAPlots"};
my $forceCopyPdf    = $ConfigMap{"forceCopyPdf"};

open (theLogFile, ">>".$logFile);
theLogFile->autoflush(1);

print theLogFile "finished reading config file \n";

%tmp = (); # temporary day : runnumber. Have duplicated entries
%day_runnumber = (); # day : runnumber, no duplicated runnumbers.

%tmp2 = (); # temporary day : runnumber, newly produced only. Have duplicated entries.
%day_runnumber_newProduced = (); # day : runnumber, no duplicated runnumbers.newly produced only

%comments = ();

for (<$sourcePath/*.asc>,<$sourcePath/*.sfs>,<$sourcePath/*/*.asc>,<$sourcePath/*/*.sfs>) {
push @files, $_ #filter out empty runs && only take files older than 90 minutes.
  if (-f $_ ? -s $_ : 0) > $fileMinimumSize and -M $_ > $fileMinimumAge/(24.*60.);
}

# get files, all (tmp) and newly produced (tmp2).

for (@files)  {
my ($day, $runnumber, $filenameNoPath) = parseFileName($_);
push (@{$tmp{$day}},$runnumber);
unless (-e "$targetPath/$day/$runnumber/$filenameNoPath") {
push  (@{$tmp2{$day}},$runnumber);
print theLogFile "found file to process : $_ \n";

}
}

foreach $day (keys %tmp){
undef %saw;
@uniqRunnumbers = grep(!$saw{$_}++, @{$tmp{$day}}); #get rid of duplicates
push(@{$day_runnumber{$day}}, $_) for @uniqRunnumbers;
}

foreach $day (keys %tmp2){
undef %saw;
@uniqRunnumbers = grep(!$saw{$_}++, @{$tmp2{$day}}); #get rid of duplicates
push(@{$day_runnumber_newProduced{$day}}, $_) for @uniqRunnumbers;
}

foreach $day (keys %day_runnumber){
`mkdir -p $sourcePath/$day`; # make target directories according to rundays
`mkdir -p $targetPath/$day`; 
`mkdir -p $targetPath/$day/$_` for @{$day_runnumber{$day}};
}

# organize files by rundays.

foreach (@files) { 
my ($day, $runnumber, $filenameNoPath) = parseFileName ($_);
unless (-e "$targetPath/$day/$runnumber/$filenameNoPath") {
`cp $_ $targetPath/$day/$runnumber/`;
print theLogFile "copied $_ to $targetPath/$day/$runnumber/ \n";
}
unless (-e "$sourcePath/$day/$filenameNoPath") {
`mv $_ $sourcePath/$day/`;
print theLogFile "moved $_ to $sourcePath/$day \n";
}
}

# read in comments. 

open (commentFile, "$commentFileName") || print theLogFile "Could not open comment file ! \n";
while (<commentFile>) {
       chomp;                          # no newline
       s/#.*//;                        # no comments
       s/^\s+//;                       # no leading white
       s/\s+$//;                       # no trailing white
       next unless length;             # anything left?
my ($whateverKey,$tmpComments) = split (/\s*:\s*/, $_,2);
$whateverKey =~ s/^\s+//;
$whateverKey =~ s/\s+$//;
push (@{$comments{$whateverKey}},$tmpComments);
}
close(commentFile);

`cp -f $commentFileName $targetPath/`;

#print theLogFile "found these comments : @{$comments{$_}}" for (keys %comments);
#print theLogFile "\n";

#############################################
# no more disturb to sourcePath from now on.#
#############################################

# at targetPath, make corresponding root files out of .asc

for (@files) { 
my ($day, $runnumber,$filenameNoPath) = parseFileName ($_);
  if (/\.asc/){
   $filenameNoPath =~ s/\.asc//; # now no postfix left in filename.
   unless (-e "$targetPath/$day/$runnumber/$filenameNoPath.tree.root") {
     if (-e "$targetPath/$day/$runnumber/$filenameNoPath.asc"){
   `root -b -q './HLTQATree.C\+(\"$targetPath\/$day\/$runnumber\/$filenameNoPath.asc\",\"$targetPath\/$day\/$runnumber\/$filenameNoPath.tree.root\")'`;
print theLogFile "finished run root -b -q HLTQATree.C\+(\"$targetPath\/$day\/$runnumber\/$filenameNoPath.asc\",\"$targetPath\/$day\/$runnumber\/$filenameNoPath.tree.root\") \n";
    }
   }
  }
}


# make QA hist.root files at targetPath

my %day_runnumber_copy;

if ($forceReDoQAPlots =~ /yes/i ) {
%day_runnumber_copy = %day_runnumber;
`rm -f $targetPath/*/*/*.hist.root`;
`rm -f $targetPath/*/*.hist.root`;
$forceCopyPdf="yes";
} else {%day_runnumber_copy = %day_runnumber_newProduced; }

foreach $day (keys %day_runnumber_copy){
    for (@{$day_runnumber_copy{$day}}){
    my $treeVersion=0;
    if ($_>10163040) {$treeVersion=1;} #version 1 has trigger info.
   `root -b -q './mkInvMassHist.C\+(\"$targetPath\/$day\/$_\/\*.tree.root\", \"$targetPath\/$day\/$_\/$_.hist.root\",$treeVersion)'` ;
   print theLogFile   "finished run root -b -q ./mkInvMassHist.C\+(\"$targetPath\/$day\/$_\/\*.tree.root\", \"$targetPath\/$day\/$_\/$_.hist.root\",$treeVersion) \n";
   }
 if (-e "$targetPath/$day/$day.hist.root") { `rm -f $targetPath/$day/$day.hist.root` ; }
 my @tmpRunsInADay = <$targetPath/$day/*/*.hist.root>;
 if (scalar(@tmpRunsInADay)>1){
     `hadd -f $targetPath/$day/$day.hist.root $targetPath/$day/*/*.hist.root`;
} else { `cp -fp $targetPath/$day/$tmpRunsInADay[0]/$tmpRunsInADay[0].hist.root $targetPath/$day/$day.hist.root`; }

print theLogFile "finished hadd -f $targetPath/$day/$day.hist.root $targetPath/$day/*/*.hist.root \n";
}

my $test = keys  %day_runnumber_copy;

if (keys %day_runnumber_copy){
if (-e "$targetPath/all.hist.root") { `rm -f $targetPath/all.hist.root` ; }
`hadd -f $targetPath/all.hist.root $targetPath/*/*.hist.root`;
print theLogFile "finished hadd -f $targetPath/all.hist.root $targetPath/*/*.hist.root \n";
addDay139AndUp("$targetPath/day139Up.hist.root","$targetPath");
print theLogFile "finished hadd -f $targetPath/day139AndUp.hist.root \n";
}


#make QA hist.pdf files at targetPath


foreach $day (keys %day_runnumber_copy){
  for (@{$day_runnumber_copy{$day}}){
    if (-e "$targetPath/$day/$_/$_.hist.root"){
   `root -b -q './mkQAPdfFile.C(\"$targetPath\/$day\/$_\/$_.hist.root\", \"$_\")'`;
print theLogFile "finished root -b -q ./mkQAPdfFile.C(\"$targetPath\/$day\/$_\/$_.hist.root\", \"$_\") \n";
    }
  }
    if (-e "$targetPath/$day/$day.hist.root"){
   `root -b -q './mkQAPdfFile.C(\"$targetPath\/$day\/$day.hist.root\", \"$day\")'`;
print theLogFile "finished root -b -q ./mkQAPdfFile.C(\"$targetPath\/$day\/$day.hist.root\", \"$day\") \n";
   }
}

if (keys %day_runnumber_copy){
  if (-e "$targetPath/all.hist.root"){
  `root -b -q './mkQAPdfFile.C(\"$targetPath\/all.hist.root\", \"All data\")'`;
print theLogFile "finished root -b -q ./mkQAPdfFile.C(\"$targetPath\/all.hist.root\", \"All data\") \n";
  }
  if (-e "$targetPath/day139Up.hist.root"){
 `root -b -q './mkQAPdfFile.C(\"$targetPath\/day139Up.hist.root\", \"day 139 and up\")'`;
print theLogFile "finished root -b -q ./mkQAPdfFile.C(\"$targetPath\/day139Up.hist.root\", \"day 139 and up\") \n";
  }
}

#cp pdf QA files to plotsPath.

`mkdir -p $plotsPath`;

if ($forceCopyPdf =~ /yes/i ) {
%day_runnumber_copy = %day_runnumber;
} else {%day_runnumber_copy = %day_runnumber_newProduced; }

   if (-e "$targetPath/all.hist.pdf") {`cp -fp $targetPath/all.hist.pdf $plotsPath/all.hist.pdf`;}
   if (-e "$targetPath/all.invM.gif") {`cp -fp $targetPath/all.invM.gif $plotsPath/all.invM.gif`;}
   if (-e "$targetPath/day139Up.hist.pdf") {`cp -fp $targetPath/day139Up.hist.pdf $plotsPath/day139Up.hist.pdf`;}
   if (-e "$targetPath/day139Up.invM.gif") {`cp -fp $targetPath/day139Up.invM.gif $plotsPath/day139Up.invM.gif`;}

   foreach $day (keys %day_runnumber_copy){
    `mkdir -p $plotsPath/$day`; # make directories according to rundays
     if (-e "$targetPath/$day/$day.hist.pdf") {`cp -fp $targetPath/$day/$day.hist.pdf $plotsPath/$day/$day.hist.pdf`;}
    `mkdir -p $plotsPath/$day/$_` for @{$day_runnumber_copy{$day}};
    for (@{$day_runnumber_copy{$day}}){ 
      if (-e "$targetPath/$day/$_/$_.hist.pdf") { `cp -fp $targetPath/$day/$_/$_.hist.pdf $plotsPath/$day/$_/$_.hist.pdf`;}
    }
  print theLogFile "finished updating $plotsPath/$day \n";
  }

# now let's make a html page.


my @totalFilesProcessed = <$targetPath/*/*/*.tree.root>;
my @totalRunsProcessed = <$plotsPath/*/*/*.hist.pdf>;
my @totalDaysProcessed = <$plotsPath/*/*.hist.pdf>;

my $hostName = `hostname`;
my $userName = `whoami`;

if (-e $htmlFileName) {`rm -rf $htmlFileName`;}
open (monitorPage, ">"."$htmlFileName");
print monitorPage "<HTML> \n";
print monitorPage "<HEAD> \n";
print monitorPage "<TITLE>HLT Online Monitoring</TITLE> \n";
print monitorPage "</HEAD> \n";
print monitorPage "<BODY> \n";
print monitorPage "<H1>HLT Online Monitoring</H1> \n";
print monitorPage "<I>This page will be updated every $sleepHours hours, the last update was on ".ctime()." </I><BR/><BR/> \n";
print monitorPage "<I>e+e- invariant mass, from day 139 and up  </I><BR/><BR/> \n";
print monitorPage "<IMG src=\"http://$plotsPathURL/day139Up.invM.gif\"> <BR/><BR/>\n";
print monitorPage "<TABLE border=\"0\"> \n";
print monitorPage "<TR> <TD align=\"right\"> Total processed files : </TD> <TD align=\"left\"> ".scalar(@totalFilesProcessed)." </TD> <TR> \n";
print monitorPage "<TR> <TD align=\"right\"> Total processed runs : </TD> <TD align=\"left\"> ".scalar(@totalRunsProcessed)." </TD> <TR> \n";
print monitorPage "<TR> <TD align=\"right\"> Total processed days : </TD> <TD align=\"left\"> ".scalar(@totalDaysProcessed)." </TD> <TR> \n";
print monitorPage "<TR> <TD align=\"right\"> Host : </TD> <TD align=\"left\"> $hostName </TD> <TR> \n";
print monitorPage "<TR> <TD align=\"right\"> User : </TD> <TD align=\"left\"> $userName </TD> <TR> \n";
print monitorPage "<TR> <TD align=\"right\"> Data source : </TD> <TD align=\"left\"> $sourcePath </TD> <TR> \n";
print monitorPage "<TR> <TD align=\"right\"> Output directory : </TD> <TD align=\"left\"> $targetPath </TD> <TR> \n";
print monitorPage "<TR> <TD align=\"right\"> html directory : </TD> <TD align=\"left\"> $plotsPath </TD> <TR> \n";
print monitorPage "</TABLE> <BR/> \n";
print monitorPage "<BR/> \n";
print monitorPage "<TABLE border=\"1\"> \n";
print monitorPage "<TR> <TD align=\"left\">Day/Run</TD>  <TD align=\"center\">QA Plots</TD> <TD align=\"left\">QA Produced time</TD>  <TD align=\"left\">Comments</TD> </TR> \n";

# day/run, plots, QA produced time, comments

my $tmpTime = -e "$targetPath/all.hist.pdf" ? ctime(stat("$targetPath/all.hist.pdf")->mtime) : "";

print monitorPage "<TR> <TD align=\"left\">all</TD> <TD align=\"center\"><A href=\"http://$plotsPathURL/day139Up.hist.pdf\">pdf</A> <TD align=\"left\"> $tmpTime </TD>  <TD align=\"left\">from day 139 and up </TD> </TR> \n";

foreach $day (reverse sort keys %day_runnumber){
  my $thisComment="";
  $thisComment .=$_ for @{$comments{"day$day"}};
  chomp($thisComment);

  $tmpTime = -e "$plotsPath/$day/$day.hist.pdf" ? ctime(stat("$plotsPath/$day/$day.hist.pdf")->mtime) : "";

print monitorPage "<TR> <TD align=\"left\"> <font color=\"#FF8040\"> day  $day </font> </TD> <TD align=\"center\"><A href=\"http://$plotsPathURL/$day/$day.hist.pdf\">pdf</A> <TD align=\"left\"> $tmpTime </TD>  <TD align=\"left\">$thisComment</TD> </TR> \n";

  foreach $runnumber (reverse sort @{$day_runnumber{$day}}){

   my $thisComment="";
   $thisComment .=$_ for @{$comments{"run$runnumber"}};
   chomp($thisComment);

   $tmpTime = -e "$plotsPath/$day/$runnumber/$runnumber.hist.pdf" ? ctime(stat("$plotsPath/$day/$runnumber/$runnumber.hist.pdf")->mtime) : "";

print monitorPage "<TR> <TD align=\"left\">run <A href=\"http://online.star.bnl.gov/admin/navigator.php?run=$runnumber\">$runnumber</A> </TD> <TD align=\"center\"><A href=\"http://$plotsPathURL/$day/$runnumber/$runnumber.hist.pdf\">pdf</A> <TD align=\"left\"> $tmpTime </TD>  <TD align=\"left\">$thisComment</TD> </TR> \n";
  }

}

print monitorPage "</TABLE> \n";
print monitorPage "</HTML> \n";

close monitorPage;

print theLogFile "finished updating $htmlFileName \n";

close theLogFile;

####################################
########## subroutines #############
####################################

sub parseFileName () { # get the day, as well as filename without path
  my $filename=shift;
my @temp1 = split (/gl3_/,$filename);
my @temp2 = split (/\//,$filename);
  return (substr($temp1[1],2,3), substr($temp1[1],0,8), $temp2[-1]); # day, runnumber, filenameNoPath
}


sub addDay139AndUp(){
  my $addedFileName =shift;
  my $thePathToDays =shift;
  chomp($addedFileName);
  chomp($thePathToDays);
  my $cmd2="";
  my $daysGt=0;
`rm -rf $thePathToDays/temp4AddRootFiles`;
`mkdir -p $thePathToDays/temp4AddRootFiles`;
  for ( <$thePathToDays/*/*.hist.root> ){
  my @temp2 = split (/\//);
  if ($temp2[-2] =~ /^\d+$/){ # if it is a day number
  `ln -s $_ $thePathToDays/temp4AddRootFiles/$temp2[-1]` unless ($temp2[-2]<139);
  $daysGt ++;
  }
 }
 if ($daysGt) {
   if (-e "$addedFilename") {`rm -f $addedFilename`;}
`hadd -f $addedFileName  $thePathToDays/temp4AddRootFiles/*.hist.root`;
}
`rm -rf $thePathToDays/temp4AddRootFiles`;
}


exit;
