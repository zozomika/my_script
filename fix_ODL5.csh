#!/bin/csh -f
# OD.L.5 errors has their bbox
# This script take the an ordinate of a point on these bbox then plus 100um 
# The result will be used to insert FILLER to fix OD.L.5 

awk ' BEGIN{\
 filler = "FILL1BWP7D5T24P96CPD"\
}\
 $3 == "OD" {\
  a1x = substr($11,2,length($11));\
  a2x = substr($13,2,length($13));\
  ax = (a1x + a2x)/2; \
  b1y = substr($12,1,length($12)-1);\
  b2y = substr($14,1,length($14)-1);\
  by = (b1y + b2y)/2;\
  printf ("size_cell [ get_cells -at {%.3f %.3f}] %s\n",ax,by,filler);\
} ' check_legality_report.csv > ! fix_OD_L5.tcl

