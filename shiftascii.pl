#!/usr/bin/perl
use Switch ;

if (@ARGV <= 3) {
  print "no or less argument. exit" ;
  print "Usage : shiftascii.pl IN_FILE OUT_FILE X[um] Y[um]" ;
  print "        X and Y is added to IN_FILE" ;
  exit ;
}

open(IN,"<$ARGV[0]") ;
open(OUT,">$ARGV[1]") ;

while (my $LINE = <IN>) {
  chomp $LINE ;
  switch ($LINE) {
    @LINE_SPLIT = split(/\s/,$LINE) ;
    case /^[-]*[0-9]+[ ]+[-]*[0-9]+[ ]+[-]*[0-9]+[ ]+[-]*[0-9]+$/ {
      printf OUT "%d %d %d %d\n",$LINE_SPLIT[0]+$ARGV[2]*1000,$LINE_SPLIT[1]+$ARGV[3]*1000,$LINE_SPLIT[2]+$ARGV[2]*1000,$LINE_SPLIT[3]+$ARGV[3]*1000 ;
    }
    case /^[-]*[0-9]+[ ]+[-]*[0-9]+$/ {
      printf OUT "%d %d\n",$LINE_SPLIT[0]+$ARGV[2]*1000,$LINE_SPLIT[1]+$ARGV[3]*1000 ;
    }
    else {print OUT "$LINE\n"}
  }
}
close(IN) ;
