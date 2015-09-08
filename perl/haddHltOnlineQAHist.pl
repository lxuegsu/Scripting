#! /opt/star/bin/perl -w

# hadd hlt qa histograms

use File::Basename;
use Getopt::Std;
use Cwd 'abs_path';     # aka realpath()

my %opt; 
getopts('htoz:b:m:adn:q:x:y:s',\%opt);
my $usage = "$0  directory  daynumber";

print "For example:
For FY12 day 050: $0  Dir  12050 
For FY12 all days: $0  Dir  12 \n";
#----

my $Dir = shift or die $usage;  # corresponds directory
my $Day = shift or die $usage;  # corresponds daynumber

my $combinedDir = $Dir ;
my $stdHistName = $Day ;

my $combinedFile = $stdHistName;
   $combinedFile .= "_hist.root";

my $pwd = `pwd`;
chomp($pwd);

if (-e $combinedDir) { print "$combinedDir exist !\n"; }
else { mkdir $pwd."/$combinedDir", or die "error! can not make directory !\n" ; }

 #mkdir $pwd."/$combinedDir", 0755  or die "can not mkdir $combinedDir :$!\n" ;

$histDir = "/star/institutions/lbl/xueliang/current";

chomp($stdHistName);
$stdHistName .= "*current_hist.root";

my $myMacroName="myHadd_day";
   $myMacroName.=$Day;

my @filesPerDay = glob ("$histDir/run10_hlt_$stdHistName");

open ( myMacro, ">$pwd/$combinedDir/$myMacroName.C");
print myMacro  "#include \"TObject.h\"  \n";
print myMacro  "#include \"TObjArray.h\" \n";
print myMacro  "#include \"TKey.h\" \n";
print myMacro  "#include \"TH1.h\" \n";
print myMacro  "#include \"TFile.h\" \n";
print myMacro  "#include \"TList.h\" \n";
print myMacro  "#include \"TObjString.h\" \n";
print myMacro  "#include \<iostream\> \n";
print myMacro  " \n";
print myMacro  "void $myMacroName(const char* newfilename = \"run11_hlt_day_$combinedFile\");  \n";
print myMacro  " \n";
print myMacro  "void $myMacroName(const char* newfilename) {  \n";
print myMacro  " \n";
print myMacro  "TObjArray* toBeAddedFiles = new TObjArray(); \n";

$m=1;
foreach $eachStdHistFile (@filesPerDay ) {
	chomp($eachStdHistFile);

	@fields = split(/\//,$eachStdHistFile) ;
	$eachStdHistFileNoPath= $fields[$#fields];
	chomp $eachStdHistFileNoPath;

	($eachJobPrefix = $eachStdHistFileNoPath) =~ s/$stdHistName//;
	chomp $eachJobPrefix;

	($eachPath = $eachStdHistFile) =~ s/$eachStdHistFileNoPath//;
	chomp $eachPath;

	if ( (-s "$eachPath$eachStdHistFileNoPath" ) ) 
	{
        print myMacro  " \n";
		print myMacro  "char  dummyName$m\[256\]; \n";
		print myMacro  "sprintf(dummyName$m,\"$eachPath$eachJobPrefix\"); \n";
		print myMacro  "toBeAddedFiles->AddLast((TObject *)(new TObjString(dummyName$m))); \n";
		$m ++;
	}
}

#print myMacro  " int goodFlag[toBeAddedFiles->GetEntries()]; \n";
#print myMacro  " for (int ii=0; ii<toBeAddedFiles->GetEntries(); ii++) goodFlag[ii]=1; \n";

print myMacro  "\n";
print myMacro  "\n";
print myMacro  "TFile* newfile = new TFile(newfilename,\"RECREATE\"); \n";
print myMacro  "TFile* oldfile1 = new  TFile(((TObjString *)(toBeAddedFiles->At(0)))->GetName(),\"READ\"); \n";
print myMacro  "\n";
print myMacro  "TList* list = oldfile1->GetListOfKeys(); \n";
print myMacro  "TIter *iter = new TIter(list); \n";
print myMacro  "TKey* key; \n";
print myMacro  "TObject* obj; \n";
print myMacro  "\n";
print myMacro  "while(key = (TKey*)iter->Next()){ \n";
print myMacro  "  TString tempStr(key->GetName()); \n";
print myMacro  "  if (tempStr.Contains(\"Beam\") || tempStr.Contains(\"Gain\") || tempStr.Contains(\"meanDcaXy\")) continue; \n";
print myMacro  "  obj = oldfile1->Get(key->GetName()); \n";
print myMacro  "  if (!obj) return; \n";
print myMacro  "  if(obj->IsA() == TDirectory::Class()){ \n";
print myMacro  "      delete obj;   \n";
print myMacro  "      obj = NULL;  \n";
print myMacro  "      continue;    \n";
print myMacro  "   }                \n";
print myMacro  " \n";
print myMacro  "   TObject* newobj = obj->Clone(); \n";
print myMacro  "   if (newobj->InheritsFrom( TH1::Class())) { \n";
# do not need to newobj->Reset(), because k begins with 1 below !!
print myMacro  "   for (int k=1; k<toBeAddedFiles->GetEntries(); k++){ \n";
print myMacro  "       TFile* f =new TFile(((TObjString *)(toBeAddedFiles->At(k)))->GetName(), \"READ\"); \n";
print myMacro  "       ((TH1 *) newobj)->Add(((TH1 *)f->Get(key->GetName()))); \n";
print myMacro  "       delete f; \n";
print myMacro  "      } \n";
print myMacro  "   } \n";

print myMacro  "  newfile->cd(); \n";
print myMacro  "  newobj->Write(key->GetName(),TObject::kOverwrite | TObject::kSingleKey); \n";
print myMacro  "  delete newobj; \n";
print myMacro  " } \n";
print myMacro  " gROOT->cd(); \n";
print myMacro  " delete key; \n";
print myMacro  " newfile->Write(); \n";
print myMacro  " newfile->Close(); \n";
print myMacro  "} \n";

close myMacro;


# print `bsub  -u aihong -q star_cas_short -L /bin/tcsh -J $combinedDir -o $pwd/$combinedDir/$myMacroName.log root4star -q -b '$pwd/$combinedDir/$myMacroName.C\+\+(\"$cumulHistName\", \"$pwd/$combinedDir/$cumulHistName\"\)'`;

#sleep 60;


#		print `bsub  -u aihong -q star_cas_cd -L /bin/tcsh -J $combinedDir -o $pwd/$combinedDir/$myMacroName.log root4star -q -b '$pwd/$combinedDir/$myMacroName.C\+\+(\"$stdHistName\", \"$pwd/$combinedDir/$stdHistName\"\)'`;





# print ` root4star -q -b '$pwd/$combinedDir/$myMacroName.C\+\+(\"$cumulHistName\", \"$pwd/$combinedDir/$cumulHistName\"\)'`;
# print ` root4star -q -b '$pwd/$combinedDir/$myMacroName.C\+\+(\"$stdHistName\", \"$pwd/$combinedDir/$stdHistName\"\)'`;

exit;
