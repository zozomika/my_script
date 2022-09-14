#!/bin/csh -f

# need to connect to ftp server first###
#ssh 172.29.138.144
########################################
alias SEND_TO_SPOOL /common/appl/ncftp-3.2.5/bin/ncftpput -u rvc_tran -p tran2rvc mftpsv01.eda.renesas.com 

#set target_gds = RCARM3N_R8A77965M_MERGE2_20171013_1418.STR.gz
#set target_cdl = LVSNET_u77965hrcarm3n000_20171013_1432.cdl.bz2
set target_pv = to_REL_RCARM3NES1.1_PR2_PV_DATA_171218.tar.bz_
#send gds
foreach file (`ls ${target_pv}*`)
    echo $file    
    SEND_TO_SPOOL . $file &
end

#send cdl
#echo $target_cdl
#SEND_TO_SPOOL . $target_cdl &

#Re-send if transfer has fail at some files
#SEND_TO_SPOOL . ${target_gds}_18 &
#SEND_TO_SPOOL . ${target_gds}_40 &
#SEND_TO_SPOOL . ${target_gds}_62 &
#SEND_TO_SPOOL . ${target_gds}_66 &

### EOF ###
