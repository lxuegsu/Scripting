#! /usr/bin/env perl
use Cwd;
use lib "/afs/rhic/star/users/fisyak/public/.dev";
use JobSubmit;
my $dir =  File::Basename::basename(Cwd::cwd());
print "dir = $dir\n";
my $jobs = 0;

my $DIR = "/star/institutions/lbl/xueliang/HaddJobs/";
my $XML = "haddjob.xml";
open (XML,">$XML") or die "Can't open $XML";
print XML '<?xml version="1.0" encoding="utf-8" ?> 
<job name="hadd" maxFilesPerProcess="1"  filesPerHour="1" simulateSubmission="false" fileListSyntax="paths">
<command>
cd  /star/institutions/lbl/xueliang/HaddJobs/
csh -x $INPUTFILE0
</command>
<stdout URL="file:/star/institutions/lbl/xueliang/HaddJobs/stdout/sched$JOBID.log" />
';

my @Daydir = glob "files/*";
print "number of days : $#Daydir\n";

foreach my $daydir (@Daydir) {
	my $day = File::Basename::basename($daydir);
	print "$daydir  \n";   # ./files/040

		my @Rundir = glob "$daydir/*";
	print "number of runs : $#Rundir\n";
	foreach my $rundir (@Rundir){
		my $run = File::Basename::basename($rundir);
		print "$rundir  \n";   # ./files/040/11040001

			my @Files = glob "$rundir/*" ;
		print "number of files : $#Files\n";
		my $FilesPerJob = 4;
		my @periods = ();
		my $all = 1;
		if ($all) {
			@periods = ('All'   => {first => '0', second => '9999999', list => ''});  # hash
		}
		my $def = {@periods};
		foreach my $file (@Files){
			my $f = File::Basename::basename($file);
			print "$f \n" ; 
#print "$def \n" ; 
			foreach my $key (sort keys %$def){
#  print "$key \n" ; 
#  print "$def->{$key}->{first} \n "; 
#  print "$def->{$key}->{second} \n "; 
				if ($f >= $def->{$key}->{first} and $f <= $def->{$key}->{second}) {
					if (! $def->{$key}->{list}) { $def->{$key}->{list} =                              $file; }
					else                        { $def->{$key}->{list} = $def->{$key}->{list} . ' ' . $file; }
				}
# print "$def->{$key}->{list} \n "; 
			}
		}

		foreach my $key (sort keys %$def) {
			my @ListAll = split ' ', $def->{$key}->{list};
			my $NJB = ($#ListAll+1)/$FilesPerJob+1;
			my $j = 0;
			for (my $jb = 1; $jb <= $NJB; $jb++){
				my $CSH = $run . "_" . $jb . ".csh";
				my $log = $run . "_" . $jb . ".log";
				$CSH = $DIR . "stdout/" . $CSH;
				$log = $DIR . "stdout/" . $log;
				print "Create $CSH\n";
				print XML "<input URL=\"file:" . $CSH ."\" />\n";
				open (OUT,">$CSH") or die "Can't open $CSH";
				print OUT "#! /usr/local/bin/tcsh -f\n";
				print OUT "source /afs/rhic/rhstar/group/.starver SL10k \n";
				my $i = 0;
				my @List = ();
				for (; $i< $FilesPerJob && $j <= $#ListAll; $i++, $j++) {
					my ($dev,$ino,$mode,$nlink,$uid,$gid,$dev, $size, $atime, $mtim, $ctime, $blksize,$blocks) = stat($ListAll[$j] );
					next if $size < 200000; # 0.2 MB limit
						push @List, $ListAll[$j];
				}
				next if  $#List == -1;
				my $list = join ' ', @List;
				print "list = $list\n";
				my $cmd .= " root.exe -q -b " . $list;
				my $rootfile = $DIR . $daydir . "/" . $run . "_" . $jb . ".root";
				$cmd .= " 'Hadd.C(\"" . $rootfile . "\")'";
				$cmd .= ">& $log";
				print OUT "$cmd\n";
			}
		}
	}
}
print XML '
</job>
';
close (XML);
