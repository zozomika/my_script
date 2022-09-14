#!/bin/csh -f

### PV/AnBaNguyen
### Get Turn Around Time of PV jobs

if ($1 == "") then
    set PV_RPT_DIR = "$PWD";
else if (-d "$1") then
    set PV_RPT_DIR = "$1";
else
    echo
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "+++ Please let me know your <Calibre Report Directory>, I will show you total real time that Calibre tool(s) spent. There are 2 ways:"
    echo "+++ 1. Give <Calibre Report Directory> as first ARGUMENT for this script. Ex: $0 </shsv/.../VERIFY/LVS_u779*_2017xxxx_xxxx>"
    echo "+++ 2. Stand at <Calibre Report Directory>, run this script."
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo
    exit
endif

set PV_RPT_DIR_abs = `readlink -f $PV_RPT_DIR`
tput setaf 4 ; echo "$PV_RPT_DIR_abs" ; tput sgr0

#set PV_RPT_DIR1   = `echo $PV_RPT_DIR | sed 's/\/$//' | awk -F'/' '{print $NF}'`
set PV_RPT_DIR1   = `basename $PV_RPT_DIR`
if (-f "$PV_RPT_DIR/mtf.calibre.log") then
    set logfile       = "$PV_RPT_DIR/mtf.calibre.log"
else if (-f "$PV_RPT_DIR/lsf.log") then
    set logfile       = "$PV_RPT_DIR/lsf.log"
else
#    set logfile       = `ls -1 $PV_RPT_DIR/*.log | head -1 >& /dev/null`
    set logfile       = `ls -1 $PV_RPT_DIR/*.log | head -1`
endif

if (! -f "$logfile") then
    tput setaf 3 ; echo "[WARN] Not found any LOGFILE" ; tput sgr0
    exit
endif

    set isLVS        = "0"
if ($PV_RPT_DIR1 =~ "LVS_*_*_*_*") then
    set isLVS        = "1"
#    set logfile_CMP  = `ls -1 $PV_RPT_DIR/*.lvs.log >& /dev/null`;
    set logfile_CMP  = `ls -1 $PV_RPT_DIR/*.lvs.log`;
endif

if ($PV_RPT_DIR1 =~ "MG_CHECK*") then
    set h_m_s         = `grep '^CPU TIME' $logfile | awk '{print $3}'`
    set hour          = `echo $h_m_s | awk -F':' '{print $1}'`
    set minute        = `echo $h_m_s | awk -F':' '{print $2}'`
    set second        = `echo $h_m_s | awk -F':' '{print $3}'`
else
    set total_second  = `cat $logfile | grep '^--- TOTAL CPU TIME = ' | grep 'REAL TIME = ' | awk -F'REAL TIME = ' '{print $NF}' | awk '{print $1}'`
    set hour          = `echo $total_second | awk '{hour = int ($1/3600) ; print hour}'`
    set remain_second = `expr $total_second - 3600 \* $hour`
    set minute        = `expr $remain_second / 60`
    set second        = `expr $remain_second - 60 \* $minute`
endif

if ("$isLVS" == "1") then
   echo "$hour $minute $second" | awk '{printf "Extraction TAT: %2.f hours %2.f minutes %2.f seconds\n", $1, $2, $3}'
else
   echo "$hour $minute $second" | awk '{printf "TAT: %2.f hours %2.f minutes %2.f seconds\n", $1, $2, $3}'
endif
#echo "$hour $minute $second" | awk '{printf "TAT (hh:mm:ss): %2.f:%2.f:%2.f\n", $1, $2, $3}'

if ("$isLVS" == "1") then
   if (! -f "$logfile_CMP") then
       tput setaf 3 ; echo "[WARN] Not found LVS COMPARISON LOGFILE" ; tput sgr0
       exit
   endif

   set total_second_ = "$total_second"
   set total_second  = `cat $logfile_CMP | grep '^--- TOTAL CPU TIME = ' | grep 'REAL TIME = ' | awk -F'REAL TIME = ' '{print $NF}' | awk '{print $1}'`
   set hour          = `echo $total_second | awk '{hour = int ($1/3600) ; print hour}'`
   set remain_second = `expr $total_second - 3600 \* $hour`
   set minute        = `expr $remain_second / 60`
   set second        = `expr $remain_second - 60 \* $minute`
   
   echo "$hour $minute $second" | awk '{printf "Comparison TAT: %2.f hours %2.f minutes %2.f seconds\n", $1, $2, $3}'

   set total_second__ = `expr $total_second_ + $total_second`
   set hour          = `echo $total_second__ | awk '{hour = int ($1/3600) ; print hour}'`
   set remain_second = `expr $total_second__ - 3600 \* $hour`
   set minute        = `expr $remain_second / 60`
   set second        = `expr $remain_second - 60 \* $minute`

   echo "$hour $minute $second" | awk '{printf "Total TAT     : %2.f hours %2.f minutes %2.f seconds\n", $1, $2, $3}'
endif

### EOF ###
