#!/bin/csh -f

set target_dir  = /common/work/haulamhuynh/
#set target_file = RCARM3N_R8A77965M_MERGE2_20170718_1744.STR.gz 
set target_file = to_REL_RCARM3NES1.1_PR2_PV_DATA_171218.tar.bz

#200MB per splited file
split -db 209710200 --verbose $target_dir/$target_file ${target_file}_

sleep 3

#bzip2 -vzk /shsv/PnR/RCARM3N/4.DESIGN/PV/99_PV_TOP/LVSNET/LVSNET_u77965hrcarm3n000_20170705_1600.cdl
#sleep 2
#mv /shsv/PnR/RCARM3N/4.DESIGN/PV/99_PV_TOP/LVSNET/LVSNET_u77965hrcarm3n000_20170705_1600.cdl.bz2 ./

echo DONE
###eof###
