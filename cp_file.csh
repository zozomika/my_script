#!/bin/csh  

set list_DIR = (  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3n000_DM_PVS_ALL.gds.gz /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3n3dg0_DM_PVS_ALL.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3nhsc0_DM_PVS_ALL.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3nir00_DM_PVS_ALL.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3nmp00_DM_PVS_ALL.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3npere_DM_PVS_ALL.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3nperw_DM_PVS_ALL.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3nrt00_DM_PVS_ALL.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3nvcd0_DM_PVS_ALL.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3nvio0_DM_PVS_ALL.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3nvp00_DM_PVS_ALL.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3nmm00_DM_PVS_ALL.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hca57ss0_DM_PVS_ALL.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hca57ss0_DM_PVS.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3n3dg0_DM_PVS.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3n3dg0_c4_const_DM_PVS.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3n3dg0_c4_dvfs_DM_PVS.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3n3dg0_dvfs_plus_pso_DM_PVS.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3n3dg0_dvfs_plus_pso_dusta_DM_PVS.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/u77965hrcarm3n3dg0_dvfs_plus_pso_rascal_dust_wrap_DM_PVS.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/rgx_hood_rgx_usc_0_DM_PVS.gds.gz  /shsv/PnR/RCARM3N/3.COMMON/31.ENV/313.PV/GDS_STRUCTURE/CHIPTOP_IP_170420_1508/rgx_lsarea_DM_PVS.gds.gz)   
set num = 1   

foreach DIR ($list_DIR)  
  if (-e $DIR ) then    
     cp -rf $DIR .
  endif 
end