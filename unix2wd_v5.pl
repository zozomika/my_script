#!/usr/bin/perl

if ($#ARGV < 0) {
    $UNIX_PATH = $ENV{PWD};
}elsif (! -e $ARGV[0]) {
    print "No such file or directory: $ARGV[0]\n";
    print "Usage:\n";
    print "     $0 <unix_path>\n";
    my $pwd = readpipe "pwd";
    print "E.g. $0 $pwd\n";
    exit;
}else {
    $UNIX_PATH = @ARGV[0];
}

my $line_site = 0;
#foreach $line (`df | grep '/vol/vol' -A2 | grep -v '172.29.143.254' | grep -v '/tool/EDA' | awk '{print \$NF}' | awk -F':' '{print \$1}'`) {
foreach $line (`df | grep 'vol' -A2 | grep -v '172.29.143.254' | grep -v '/tool/EDA' | awk '{print \$NF}' | awk -F':' '{print \$1}'`) {
    chomp $line;
    push (@ARR_LINE,$line);
    if (grep /^$line\//,$UNIX_PATH) {
        my $u_head    =  "\/".(split /\//,$line)[1];     # unix head part 
        my $w_head    =  "\\\\".$ARR_LINE[$line_site-1]; # windows head part
        my $u_tail    =  (split /$u_head/,$UNIX_PATH)[1];
        my $w_tail    =  $u_tail;
           $w_tail    =~ s#/#\\#g;
           $w_tail    =~ s#RCARM3N#RCARM3~1# if ($line eq "\/shsv\/PnR");

        printf ("UNIX:   %15s$u_tail\n", $u_head);
        printf ("WIND:   %15s$w_tail\n", $w_head);
        last;
    }
    $line_site+=1;
}
### EOF ###

