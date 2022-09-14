#!/bin/csh -f 
set name = $1
awk '/^ set /&&/'$name'/&&$9=="{AP:0}" { a = substr($13,3,length($13)); b = substr($14,1,length($14)-1);  printf "layouttext \"" "'$name'\" "  a " " b " WMA \n"; exit}  ' 20180516/SGMII_PG_ANALOG_20180516.dump_mod
