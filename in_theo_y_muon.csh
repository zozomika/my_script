#!/bin/csh -f
#----------------------------------------------------------------------------------------------
# 1. Run: in_theo_y_muon.csh   DRC_RES.db                                                     |
# 2. Choose which error you want to print out in DRC_RES.db: at collumn PRINT_OUT choose 'yes'|
# 3. Run again: in_theo_y_muon DRC_RES.db > 'report.err'                                      |
#----------------------------------------------------------------------------------------------
if ($1 == "") then
 printf "Input invalid! Please run with DRC_RES.db:  $0 DRC_RES.db \n"
else
 setenv file  $1
 #source drc_analyzing.csh
 if (-e $1.out ) then
#  printf "------------------------------------------------Notice\!\!\!-------------------------------------------------------\n"
#  printf "Please notice! Choose error type you want to print out in file <$1.out>\n"
#  printf "----------------------------------------------------------------------------------------------------------------\n"
 else 
   printf "---------------------------------------------------Notice\!\!\!-------------------------------------------------------\n"
   printf "$1.out is being created -> Wait for analyzing \!\!\!\n"
   printf "Z.z.z....\n"
  source /home/u/haulamhuynh/HLH_script/drc_report/drc_analyzing.csh
   if (-e $1.out) then
    printf "$1.out is done\! -> Please setting in file $1.out by choosing yes/no in collumn PRINT_OUT\!\!\!\n"
   printf "-------------------------------------------------------------------------------------------------------------------\n"
   endif
 endif
endif
  awk '{\
   if ((NR==FNR)&&(($NF=="yes")||($NF=="y")) ) {\
    a[$1];\
    b[$1]=$2;\
    c[$1]=$3;\
    next;\
   }\
   for (i in a ){\
    if ((FNR>=b[i])&&(FNR<=c[i])) {\
     if ($NF == "no") {\
     } else {\
      print\
     }\
    }\
   }\
  }\
  END{\
   for (i in a){ \
  #  print b[i] \
   }\
  }' $1.out $1
