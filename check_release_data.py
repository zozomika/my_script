#!/usr/bin/python
#.---------------- Author: HauHuynh
#.---------------- Function: Check the compatible between release data
#.---------------- Usage: script.py <verification_report>
#.---------------- Ver00: Expectation: each type of used cdl files and gdsmerge2 are same
#.---------------- Ver01: ?
#                         
import sys, time, datetime
#from openpyxl import load_workbook, Workbook
#from openpyxl.styles import PatternFill, Border, Side, Alignment, Protection, Font, colors, NamedStyle
#from openpyxl.comments import Comment
#from openpyxl.comments.comment_sheet import Properties
import re, os, glob, fnmatch

t0 = time.time()

#wb0 = load_workbook(sys.argv[1])
##wb1 = load_workbook(sys.argv[2])
#
## Setting
#ignore_sheet = ["Rule","E3_History", "Delete(E3)","Old_V3M_History","hard_macro (MIPI)","D3_History"]
#ignore_cell = ["Use","use"]
#
## Initial declaration
#
#stamp_out = '{:%y%m%d_%H%M}'.format(datetime.datetime.now()) #Ex: 171103_1234
## For LMS
#wb0_sheets = wb0.sheetnames
#gds_list = []
#cdl_list = []
#nwpg_list = []
## Output File
#gds_out = "fr_LMS_gds_" + stamp_out + ".txt"
#cdl_out = "fr_LMS_cdl_" + stamp_out + ".txt"
#nwpg_out = "fr_LMS_nwpg_" + stamp_out + ".txt"
#gds = open(gds_out, 'w')
#cdl = open(cdl_out, 'w')
#nwpg = open(nwpg_out, 'w')
#
## For Verification report
#wb1_sheets = wb1.sheetnames
#gdsmerge_list = []
#cdlcat_list = []
## Output File
#gds_verify = "fr_Verification_report_gds_" + stamp_out + ".txt"   
#cdl_verify = "fr_Verification_report_cdl_" + stamp_out + ".txt"   
#gdsmerge = open(gds_verify, 'w')
#cdlcat = open(cdl_verify, 'w')

# Define function to get file by an address
def find_pattern (pattern, path):
    result = []
    for root, dirs, files in os.walk(path):
        for name in files:
            if fnmatch.fnmatch(name, pattern) :
                result.append(os.path.join(root, name))
    return result
# Below function has riskly to use
#def find_pattern (pattern, path):
#        result = []
#        for file in glob.glob(path+pattern):
#                result.append(file)
#        print result

# Define function to write output file by list
def write_out (list_write_out, output):
        for x in sorted(set(list_write_out)):
                output.write(x)


# Analysing LMS
#for s0 in wb0_sheets:
#        if s0 in ignore_sheet:
#                continue
#        else:
#                #wb0_sheets.remove(s0) 
#                max_row = wb0[s0].max_row
#                max_col = wb0[s0].max_column
#                for r_cnt in range(1,max_row+1):
#                        for c_cnt in range(1, max_col+1):
#                                if wb0[s0].cell(row=r_cnt, column=c_cnt).value == 'gds':
#                                        if wb0[s0].cell(row=r_cnt, column=c_cnt-1).value in ignore_cell and wb0[s0].cell(row=r_cnt, column=c_cnt+1).value:
#                                                gds_path = wb0[s0].cell(row=r_cnt, column=c_cnt+1).value
#                                                if os.path.isdir(gds_path):
#                                                #gds.write(gds_path)
#                                                        for file in find_pattern('*.gds*', gds_path):
#                                                                gds_list.append(file+"\n")
#                                                                #gds.write(file+"\n")
#                                                elif glob.glob(gds_path+'*.gds*') or fnmatch.fnmatch(gds_path, '*.gds*'):
#                                                        #gds.write(gds_path+"\n")
#                                                        gds_list.append(gds_path+"\n")
#
a =  os.getcwd()
if os.path.isdir(a):
  for path in os.listdir(a):
     print path
      

t1 =  time.time()
print "Execution time: ", t1-t0

#eof
