#!/bin/csh -f
#source /home/u/hacnguyen/calibre_server/check_server.csh
source ~/check_server_run_file.csh
printf "\n"
echo "---------------------------------------------------------------SUMMARY--------------------------------------------------------------------"
egrep "Remain_memory" $PWD/check_calibre_server.log
printf "\n"
echo "-------------------------------------------------------------SUMMARY_CALIBRE--------------------------------------------------------------"
bqueues | grep 'QUEUE_NAME\|AL_Cal' | awk '{print $1,"\t",$4,"\t",$8,"\t",$9,"\t",$10,"\t"}'

if (-e $PWD/check_calibre_server.log) then
 rm -f $PWD/check_calibre_server.log
 rm -f $PWD/mem_total
 rm -f $PWD/cpu_total
 rm -f $PWD/dedi_total
 rm -f $PWD/dedicated_list
 rm -f $PWD/total_server.list
endif
