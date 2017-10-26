#!/bin/csh -f
# OD.L.5 errors has their bbox
# This script take the an ordinate of a point on these bbox then plus 100um 
# The result will be used to insert FILLER to fix OD.L.5 

#awk '{if ( $1 ~ /OD.L.5/) {getline; while ( getline >0) { if ( $1 ~ /^p/){ getline; ax="$1"; ay="$2";printf ("x y avarage is %.3f ", ($ax+$bx)/2);getline; bx="$1";by="$2"; print ($ay+$by)/2 ;break } } } }' *.db
#awk '{if ( $1 ~ /OD.L.5/) {getline; while ( getline >0) { if ( $1 ~ /^p/){ while (getline > 0){ getline; if ( $1 ~ /^p/){break}else {getline;print;break}} } } } }' *.db

awk '{\
 if ( $1 ~ /OD.L.5/) {\
  while ( getline >0) {\
   if ($0 ~ /^p/) {\
    n++;\
    getline;\
    if ($1 ~ /^-/) {\
     if (length ($1) == 7) {\
      a1x = substr ($1,1, 4)\
      a2x = substr ($1,5, 3)\
      printf a1x "." a2x " "\
      if ($2 ~ /^-/) {\
       if (length ($2) == 7) {\
        b1x = substr ($2,1, 4)\
        b2x = substr ($2,5, 3)\
        print b1x "." b2x\
       }\
       else {\
        b1x =  substr ($2, 1, 5)\
        b2x = substr ($2,6, 3)\
        print b1x "." b2x\
       }\
      }\
     }\
     else {\
      a1x =  substr ($1, 1, 5)\
      a2x = substr ($1,6, 3)\
      printf  a1x "." a2x " "\
      if ($2 ~ /^-/) {\
       if (length ($2) == 7) {\
        b1x = substr ($2,1, 4)\
        b2x = substr ($2,5, 3)\
        print b1x "." b2x\
       }\
       else {\
        b1x =  substr ($2, 1, 5)\
        b2x = substr ($2,6, 3)\
        print b1x "." b2x\
       }\
      }\
     #print\
     }\
    }\
   }\
   if (n == 460) {\
    exit\
   }\
  }\
 }\
}' *.db >! origin_of_drc_error

