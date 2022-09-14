#!/bin/csh -f

if ($1 == "") then
    set PV_RPT_DIR = "$PWD";
else if (-d "$1") then
    set PV_RPT_DIR = "$1";
else
    echo
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "+++ Please let me know your <Calibre Report Directory>, I will show you its INPUT(s) [GDS or(and) NETLIST-PG]. There are 2 types:"
    echo "+++ 1. Give <Calibre Report Directory> as first ARGUMENT for this script. Ex: $0 </shsv/.../VERIFY/LVS_u779*_2017xxxx_xxxx>"
    echo "+++ 2. Stand at <Calibre Report Directory>, run this script."
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo
    exit
endif

set PV_ENV_DIR  = `echo $PV_RPT_DIR | awk -F'/VERIFY/' '{print $1}'`
set PV_RPT_DIR1 = `echo $PV_RPT_DIR | sed 's/\/$//' | awk -F'/' '{print $NF}'`

### Determine type of report #########################################################
    set isLVS        = "0"
if      ($PV_RPT_DIR1 =~ "LVS_*_*_*_*") then
    set isLVS        = "1"
    set CMP_RPT_FILE = `ls -1 $PV_RPT_DIR/*.rep`;
    set     RPT_FILE = "$CMP_RPT_FILE.ext";
    set LAY_IDENTIFY = "LAYOUT NAME"
else if ($PV_RPT_DIR1 =~ "ERC_*_*_*_*") then
    set     RPT_FILE = `ls -1 $PV_RPT_DIR/*.rep.ext`;
    set LAY_IDENTIFY = "LAYOUT NAME"
else
    set     RPT_FILE = `ls -l $PV_RPT_DIR/*.rep | grep '^-rw-r--r--' | awk '{print $NF}'`
    set LAY_IDENTIFY = "Layout Path(s)"
endif

### Find Layout ######################################################################
set stamp_MERGE2   = `grep "^$LAY_IDENTIFY" $RPT_FILE | awk '{print $3}' | awk -F'MERGE2_' '{print $NF}' | sed 's/.STR.gz//g'`
set log_MERGE2     = `ls -1 $PV_ENV_DIR/GDSMERGE_2/LOG/*$stamp_MERGE2*log`
set stamp_MERGE1   = `grep '\/RESULT_1\/' $log_MERGE2 | grep 'GLIB NAME' | awk '{print $4}' | awk -F'MERGE1_' '{print $NF}' | sed 's/.STR.gz//g'`
set log_MERGE1     = `ls -1 $PV_ENV_DIR/GDSMERGE_1/LOG/*$stamp_MERGE1*log`
set PnR_GDS_top    = `grep '^                    GLIB NAME = \.\.\/INPUT\/' $log_MERGE1 | awk '{print $4}' | sed "s#^..#$PV_ENV_DIR#"`
set exist_subGDS   = `grep '^                    GLIB NAME = ' $log_MERGE1 | grep 'gdsii\.gz' | awk '{print $4}' | grep -v '^\.\.\/INPUT\/' | head -1`

### Find Netlist #####################################################################
if ($isLVS == "1") then
set stamp_LVSNET   = `grep '^SOURCE NAME' $CMP_RPT_FILE | awk '{print $3}' | awk -F'_' '{print $(NF-1)"_"$NF}' | sed 's/.cdl//g'`
set log_CDLCAT     = `ls -1 $PV_ENV_DIR/LVSNET/LOG/*$stamp_LVSNET*.log`
set stamp_V2LVS    = `grep "^ CDL : $PV_ENV_DIR/LVSNET/v2lvs_" $log_CDLCAT | grep '.cdl'$ | awk -F"$PV_ENV_DIR/LVSNET/v2lvs_" '{print $NF}' | sed 's/.cdl//g'`
set log_V2LVS      = `ls -1 $PV_ENV_DIR/LVSNET/LOG/v2lvs_${stamp_V2LVS}.log`
set Netlist_PG_top = `grep '^Running ' $log_V2LVS | sed 's/ /\n/g' | grep "$PV_ENV_DIR/LVSNET/INPUT/"`
set run_V2LVS      = `ls -1 $PV_ENV_DIR/LVSNET/run\.v2lvs_$stamp_V2LVS.bat`
set exist_subNET   = `grep '^  \-v ' $run_V2LVS | awk '{print $2}' | grep -v "$Netlist_PG_top" | head -1`
endif


### Print        #####################################################################
        echo
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>> INPUT DATA (data stream out from PnR tool) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        echo "=== GDS ============================================================================================"
    if ("$exist_subGDS" != "") then
        echo "------- TOP ---"
    endif
        md5sum $PnR_GDS_top;
    if ("$exist_subGDS" != "") then
        echo "------- SUB ---"
        grep '^                    GLIB NAME = ' $log_MERGE1 | grep 'gdsii\.gz' | awk '{print $4}' | grep -v '^\.\.\/INPUT\/' | xargs md5sum
    endif
if ($isLVS == "1") then
        echo "=== NETLIST-PG ====================================================================================="
    if ("$exist_subNET" != "") then
        echo "------- TOP ---"
    endif
        md5sum $Netlist_PG_top;
    if ("$exist_subNET" != "") then
        echo "------- SUB ---"
        grep '^  \-v ' $run_V2LVS | awk '{print $2}' | grep -v "$Netlist_PG_top" | xargs md5sum
    endif
endif
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

### EOF ###
