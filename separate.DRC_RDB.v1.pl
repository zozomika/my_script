#!/usr/bin/perl

my $Time         = `date '+%y%m%d_%H%M'`; chomp $Time;
#system "echo -n 'BEGIN '; date '+%H%M%S'";
if ($#ARGV < 0) {die "Usage:\n      $0 -in <DRC_RES.db> -out <outfilename> -errlist <list of errors || list errors file>\n"}
else            {&GetOption}

my @ArrErrorList = ();
if (-f $ErrorList) {@ArrErrorList = (`cat $ErrorList`)}
else               {@ArrErrorList = split /\s+/, $ErrorList}
chomp @ArrErrorList;

print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
print "Input RDB file  : $RDBFile\n";
print "Output RDB file : $FilteredRDBFile\n";
print "Errors List     : @ArrErrorList\n";
print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";

### Initial setting ###
@arr_tmp      = ("", "");
$ErrorNum     =  0;
$LastPointNum =  0;
$flag1        = -1;
$flag_write   =  0;
$cnt_ErrorID  =  0;

### Read and write data ###
open (DRC_RDB, "<$RDBFile") or die "Can not open file to read $RDBFile ($!)\n";
open (Filtered_DRC_RDB, ">$FilteredRDBFile") or die "Can not open file to write $FilteredRDBFile ($!)\n";
print Filtered_DRC_RDB (`head -1 $RDBFile`);
for $line (<DRC_RDB>) {
    chomp $line;
    $arr_tmp[0] = $arr_tmp[1];
    $arr_tmp[1] = $line;
    if ($flag_write) {
        print Filtered_DRC_RDB "$line\n";
    }else {
        last if ($cnt_ErrorID == $#ArrErrorList+1);
    }

    if ((split / /,$line)[1] eq "") {
        if (grep (/^$line$/,@ArrErrorList)) {
            $cnt_ErrorID+=1;
            printf ("   %3d. $line\n",$cnt_ErrorID);
            print Filtered_DRC_RDB "$line\n";
            $ErrorID = $line;
            $flag_write = 1;
            next;
        }
    }

    if ($arr_tmp[0] eq $ErrorID) {
        $ErrorNum = (split /\s/,$line)[0];
        next;
    }
    if ($line =~ /^p $ErrorNum / || $line =~ /^e $ErrorNum /) {
        $flag1 = 0;
        $LastPointNum = (split /\s/,$line)[2];
    }
    if ($flag1 >= 0 and $flag1 < $LastPointNum) {
        $flag1+=1;
    }elsif ($flag1 == $LastPointNum) {
        $flag1      = -1;
        $flag_write =  0;
    }
}
close (Filtered_DRC_RDB);
close (DRC_RDB);
chmod  0755, $FilteredRDBFile;

sub GetOption {
    $siteARGV = 0;
    for (@ARGV) {
        chomp;
        if ($_ eq "-in")               {$RDBFile            = $ARGV[$siteARGV+1]}
        if ($_ eq "-out")              {$FilteredRDBFile    = $ARGV[$siteARGV+1]}
        if ($_ eq "-errlist")          {$ErrorList          = $ARGV[$siteARGV+1]}
        $siteARGV+=1;
    }
    unless (-f $RDBFile)               {$RDBFile            = "DRC_RES.db"}
    if     ($FilteredRDBFile eq "")    {$FilteredRDBFile    = (split /\.db/,$RDBFile)[0]."_$Time.db"}
}

#system "echo -n 'END   '; date '+%H%M%S'";
### EOF ###
