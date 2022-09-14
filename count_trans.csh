#!/bin/csh

test -f total_transitors_count.txt  && rm -rf total_transitors_count.txt                     
set input = $1
awk 'BEGIN{\
   n = 0\
   while ( getline < "'$input'" >0) {\
      if ($0~/  CORRECT/&& $0!~/R7F702Z19_CHIP/ && NF==3) {\
         a[$NF]=n  \
         n++\
      }\
   }\
   init_flag = 0\
   cnt_inst = 0\
}\
{\
   if ($0~/LAYOUT CELL NAME:/) {\
      if ($NF in a) {\
          inst_name = $NF\
          inst_flag  = 1\
          arr_inst_name[cnt_inst] = $NF\
          #print "Check inst: " arr_inst_name[cnt_inst]\
          #cnt_inst++\
      }\
   }\
   if ($0 ~/^NUMBERS OF OBJECTS/&&NF==3){\
      reset_flag = 1  \
   } \
   if ($0 ~/^ Total Inst/&& NF==4){\
      init_flag ++   \
      inst_tmp = $(NF-1) \
   }\
   if (inst_tmp!="") {\
      if (inst_flag==1&&init_flag==1) {\
         arr_trans_init[inst_name] = inst_tmp\
         #print "Check trans num init of: ", inst_name, arr_trans_init[inst_name]\
         inst_tmp = ""\
      }\
      if (reset_flag==1){\
         arr_trans_after[inst_name] = arr_trans_init[inst_name]\
         #print "Check trans num init=after: " arr_trans_after[inst_name]\
         init_flag = 0\
         inst_flag = 0\
         reset_flag = 0\
         cnt_inst++\
      }\
   }\
   if (inst_tmp!="") {\
      if (inst_flag==1&&init_flag==2) {\
         arr_trans_after[inst_name] = inst_tmp\
         #print "Check trans num after: " inst_name, arr_trans_after[inst_name]\
         inst_tmp = ""\
         init_flag = 0 \
         inst_flag=0\
         reset_flag = 0\
         cnt_inst++\
      }\
   }\
   if ($NF=="pins)" && $(NF-2) in a){\
      inst_tmp2 = $(NF-2)\
      inst_num[inst_tmp2] = inst_num[inst_tmp2] + $(NF-3)\
   }\
}\
END {\
   for (i=0; i<length(arr_inst_name); i++) {\
      totalEachInst =  arr_trans_init[arr_inst_name[i]]*inst_num[arr_inst_name[i]]*0.5 \
      total = total + totalEachInst\
      totalEachInstAfter =  arr_trans_after[arr_inst_name[i]]*inst_num[arr_inst_name[i]]*0.5 \
      totalAfter = totalAfter + totalEachInstAfter\
      print arr_inst_name[i], arr_trans_init[arr_inst_name[i]],  arr_trans_after[arr_inst_name[i]], inst_num[arr_inst_name[i]]/2 >> "total_transitors_count.txt"\
   }\
   print "###  TOTAL TRANSITOR COUNTED: " total\
   print "###  TOTAL TRANSITOR COUNTED: " total >> "total_transitors_count.txt"\
   print "###  TOTAL TRANSITOR COUNTED AFTER TRANSFORMATION: " totalAfter >> "total_transitors_count.txt"\
}' $input
