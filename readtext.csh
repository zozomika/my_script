#!/bin/csh -f
set a = `cat $argv[1] | wc -l`
perl -n -e "print if ( 1 .. $a)" $1 | less
