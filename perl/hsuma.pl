#! /usr/bin/env perl
use Cwd;
use lib "/afs/rhic/star/users/fisyak/public/.dev";
use JobSubmit;
my $dir =  File::Basename::basename(Cwd::cwd());
print "dir = $dir\n";
#my $jobs = 0; #Xue
my @Files = glob "*/st_hlt*.root";
print "no of files : $#Files\n";
my @periods = ();
my $all = 1;
if ($all) {
 @periods = ('All'   => {first => '0', second => '9999999', list => ''});
}
# else {
#}
#my @Run   = sort keys %runs; #Xue
my $FilesPerJob = 40;
my $def = {@periods};
my $fno = 0;
foreach my $file (@Files) {
  my $f = File::Basename::basename($file);# print "$file";
  $f =~ s/\.root//g;
  $f =~ s/adc_//g;
  my @ss = split /_/, $f; 
  $f = $ss[0];# print " ==> $f\n";
  
  foreach my $key (sort keys %$def) {
    #print "$f : $key => ( $def->{$key}->{first} - $def->{$key}->{second}) \n";
    if ($f >= $def->{$key}->{first} and $f <= $def->{$key}->{second}) {
      if (! $def->{$key}->{list}) { $def->{$key}->{list} =                              $file; }
      else                        { $def->{$key}->{list} = $def->{$key}->{list} . ' ' . $file; }
 #     print "$def->{$key}->{list} \n";  # for test Xue 11 Apr 2010
    }
  }
}
foreach my $key (sort keys %$def) {
        my $DIR = "/direct/star+institutions+lbl/xueliang/offlinedEdxCali/workdir/dEdx/RunXHLTP10if_calib/";
	my $XML = "haddjob.xml";
	open (XML,">$XML") or die "Can't open $XML";
	print XML '<?xml version="1.0" encoding="utf-8" ?> 
<job name="hadd" maxFilesPerProcess="1"  filesPerHour="1" simulateSubmission="false" fileListSyntax="paths">
	<command>
cd  /direct/star+institutions+lbl/xueliang/offlinedEdxCali/workdir/dEdx/RunXHLTP10if_calib/
csh -x $INPUTFILE0
	</command>
         <stdout URL="file:/direct/star+institutions+lbl/xueliang/offlinedEdxCali/workdir/dEdx/RunXHLTP10if_calib/log/sched$JOBID.log" />
';
#  print "$key => ( $def->{$key}->{first} - $def->{$key}->{second}) = |$def->{$key}->{list}|\n";
  my @ListAll = split ' ', $def->{$key}->{list};
  my $NJB = ($#ListAll+1)/$FilesPerJob+1;
  my $j = 0;
  for (my $jb = 1; $jb <= $NJB; $jb++) {
    my $CSH = $jb . ".csh";
    my $log = $jb . ".log";
    $log = $DIR . $log;
    print "Create $CSH\n";
    print XML "<input URL=\"file:" . $DIR .  $CSH ."\" />\n";
    open (OUT,">$CSH") or die "Can't open $CSH";
    print OUT "#! /usr/local/bin/tcsh -f\n";
    print OUT "source /afs/rhic/rhstar/group/.starver SL10f \n";
    my $i = 0;
    my @List = ();
    for (; $i< $FilesPerJob && $j <= $#ListAll; $i++, $j++) {
      my ($dev,$ino,$mode,$nlink,$uid,$gid,$dev, $size, $atime, 
          $mtim, $ctime, $blksize,$blocks) = stat($ListAll[$j] );
      next if $size < 500000; # 0.5 MB limit
      push @List, $ListAll[$j];
    }
    next if  $#List == -1;
    my $list = join ' ', @List;
    print "list = $list\n";
 #   print "======================> $List[0] - $List[$#List]\n";
    
    my @be = (File::Basename::basename($List[0]), File::Basename::basename($List[$#List]));
    for (my $i = 0; $i < 2; $i++) {
      my $f = $be[$i];
      $f =~ s/\.root//g;
      $f =~ s/adc_//g;
#      my @ss = split /_/, $f;
#      $f = $ss[0];
      $be[$i] = $f; 
    }
    print "b/e => $be[0] - $be[1]";
    my $job = $be[0] . "_" . $be[1];
    my $rootfile =  $key . "_" . $job . ".root";
  #  my $log  = $job . ".log";
    if ( -r $rootfile ) {print  "\tDone\n"; next;}
    else {print "\n";}
 #   my $cmd = " bsub -o $log -N -q star_cas_big";
#    my $cmd = " bsub -o $log -N -q star_cas_prod";
    my $cmd .= " root4star -q -b " . $list;
#    print "$cmd\n";
    #  $cmd .= " '/afs/rhic/star/users/fisyak/.dev/Hadd.C(\"" . $rootfile . "\")'";
    $cmd .= " 'Hadd.C(\"" . $rootfile . "\")'";
    $cmd .= ">& $log";
    print OUT "$cmd\n";
  }
  print XML '
  </job>
  ';
  close (XML);
}
