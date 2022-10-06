#!/usr/local/Anaconda3-5.2.0/bin/python3.6
"!/usr/local/python-2.7.9/bin/python"
""" ================================================================================ #
 
  Project: RV28F
  File name: excl_fp_rpt.py
  Function: Main wrapper to generate Wire statistic with available input data
  Author: RVC/BE23/Hau Huynh
 ================================================================================ """
#import sys
#sys.path.append("/design04/u2a8_bed2_vf/u2a8/data/u2a8/5_layout/COMMON_PL/15_script/scripts/20_wireStat/")
import fprptsrc

# input
init_floorplan_file = "../../logs/100_init_design_210413_2014.log"
# output
output   = "./U2A6-BEDQuality-0001-01-Floorplan_CN_f5090_1113a.xlsx"
# Main script
if __name__ == "__main__":
  #fprptsrc.clone_wb2 ("../U2A6-BEDQuality-0001-01-Floorplan_CN_f5090_0013d.xlsx", output)
  fprptsrc.xcl_fpstat (init_floorplan_file, output)
  
#eof
