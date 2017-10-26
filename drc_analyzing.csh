#!/bin/csh -f
#if ($1 == "") then  
# printf "Input invalid! Please run with DRC_RES.db:  $0 DRC_RES.db \n"
#else
#set file = $1
#set error_type = $2
awk ' BEGIN{\
 code = 1\
 line = 0\
 n = 0\
 m = 0\
 z = 0\
}\
{\
 m++\
 n++\
 if (( $2 == "{") || ($2 == "{@")){\
  error_array[code] = $1\
  error_end_line[line] = n\
  code++\
  line++\
 #Start line of each error code\
  error_start_line[$1] = FNR- 2 \
 }\
}\
 END{\
 k = length (error_array) \
 error_end_line[k] = NR+3\
 printf ("%-45s %-20s %-20s %-20s \n","ERROR NAME","FROM LINE","TO LINE","PRINT_OUT [yes/no]") > FILENAME".out"\
 printf ("%-45s %-20s %-20s %-20s \n","__________","_________","_______","__________________") > FILENAME".out"\
 print "" > FILENAME".out"\
 for (j=1;j<=k;j++) {\
   printf ("%-45s %-20s %-20s %-20s \n",error_array[j],error_start_line[error_array[j]],error_end_line[j]-3,"no") > FILENAME".out"\
 }\
} ' $file #> report_DRC_lower_for_CHIP
#endif
