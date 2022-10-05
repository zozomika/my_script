#!/usr/bin/python
# ================================================================================ #
#
#  Project: RV28F
#  File name: hsscp2p.py
#  Function: to generate HSSC/P2P environment with available input data
#  Author: RVC/BE31/Hau Huynh
# ---------------------------------------------------------------------------------#
#  History
#  v1r0 : Nov.11 2019  by hauhuynh/RVC/BE31
#       - updated script to get power name of <OTHERS> cases in sample_w_w mode
#       - upgrade HSSC to version 6.0.0
#       - used LSF_n_OPTION_span "span[hosts=1]"
#  v2r0 : Nov.26 2019  by hauhuynh/RVC/BE31
#       - change to python format
#       - optimize source code
# ================================================================================ #
import re, os, glob, fnmatch
from shutil import copy, copyfile


# Define functions
def my_dict_2d(mydict, process, temper, probe_list):
    # Two dimension dictionary to store process mode (worst/typ) and corresponding temperature (175/25*C)
    try:
        mydict[process].update({temper: probe_list})
        # mydict.update({key1:{key2:val}})
    except:
        mydict[process] = {temper: probe_list}
    return mydict


def make_my_dir(root_dir, dir_name):
    # To create non-existent directory
    #dir_path = os.path.expanduser(root_dir + "/" + dir_name)
    dir_path = os.path.expanduser(root_dir + "\\" + dir_name)
    # if os.path.isdir(dir_path):
    #  print  "Existed %s" %dir_name
    # else:
    try:
        os.mkdir(dir_path, 0755)
    except:
        print "Existed %s! Exit!" % dir_name
        exit
    return dir_path


def mod_string_by_text(line, keyword, replace_str):
    # To modify a specific word by another word
    replace_str = str(replace_str)
    if not re.match(r'^\#.*$', line):
        try:
            line = line.replace(keyword, replace_str, 1)
            # line = re.sub(keyword, replace_str, line)
        except:
            pass
    return line


def mod_string_by_list(line, insert_arr, keyword, net_name, text_list):
    # To insert a text file into specific line
    text_list = open(text_list, 'r')
    if re.match('.*%s.*' % keyword, line):
        for text in text_list:
            if re.match('.* %s .*' % net_name, text):
                insert_arr.append(text)
    text_list.close()
    return insert_arr


def write_out(list_write_out, output):
    # To append data to an existing file
    # for x in sorted(set(list_write_out)):
    #  output.write(x)
    for i in list_write_out:
        output.write(i)


def edit_my_tech(tech_file, cell_name, net_name, process, temper, probe_file, probe_key):
    """To edit HSSC technology file from the original technology file

       Parameters:
         tech_file (string): name of target tech file
         cell_name (string): is the top cell name of GDS for HSSC extraction
         net_name (list): list name of power net for HSSC extraction
         process (string): is the current process used for RV28F
         temper (string): is the temperature comebined with process as a condition
         probe_file (string): file stores all probe coordinate information
         probe_key (string): mark as where probe file is implemented in

       Output:
         A moderation tech file contains all information for HSSC extraction
    """
    tech_file_line_mod = []
    tech_file_mod = str(tech_file)
    tech_file = open(tech_file, 'r')
    tech_file_lines = tech_file.readlines()
    for line in tech_file_lines:
        line_new = line.strip()
        line_new = mod_string_by_text(line_new, r'INPUT_CELLNAME', cell_name)
        line_new = mod_string_by_text(line_new, r'INPUT_NETNAME', net_name)
        line_new = mod_string_by_text(line_new, r'INPUT_EXTERNALGRD', ProcessAll[process])
        line_new = mod_string_by_text(line_new, r'INPUT_EXTERNALTEMP', TemperAll[temper])
        tech_file_line_mod.append(line_new + "\n")
        mod_string_by_list(line_new, tech_file_line_mod, probe_key, net_name, probe_file)
    tech_file.close()
    tech_file_mod = open(tech_file_mod, 'w')
    write_out(tech_file_line_mod, tech_file_mod)
    tech_file_mod.close()


def mk_probe_file_exclusion(input_file, output_file, exclusive_target):
    ouput_file_line = []
    input_file = open(input_file, 'r')
    output_file = open(output_file, 'w')
    for i in input_file.readlines():
        i = i.strip()
        if not re.match(r'^\#.*', i):
            # ignore comment-out lines
            i_arr = i.split()
            supply_net = i_arr[1]
            if supply_net not in exclusive_target:
                # skip the excluded net
                ouput_file_line.append(i)
    write_out(ouput_file_line, output_file)
    input_file.close()
    output_file.close()


def my_probe_dir_generator(cell_name, process, temper, list_net, run_file, tech_file, probe_file, layouttext_file,
                           probe_key, layouttext_key):
    # Main script is used to build the environment: make dir, create tech file and run file
    probe_dir = 'sample_' + process[0] + '_' + temper[0]
    top_dir = make_my_dir(os.getcwd(), probe_dir)
    # list_net_exclusive = list_net.pop('other')
    for k, v in list_net.items():
        sub_dir = make_my_dir(top_dir, v)
        copy(run_file, sub_dir)
        copy(tech_file, sub_dir)
        run_file_name = os.path.basename(run_file)
        tech_file_name = os.path.basename(tech_file)
        run_file_path = os.path.expanduser(sub_dir + "\\" + run_file_name)
        tech_file_path = os.path.expanduser(sub_dir + "\\" + tech_file_name)
        edit_my_tech(tech_file_path, cell_name, v, process, temper, probe_file, probe_key)
        # print sub_dir


# setting
#######################
## no need to change ##
#######################
# Parameters
# Declare product name
hsscP2PProduct = "R7F702301"
# Declare process (typical, worst) and temperature (typical/25oC, worst/170oC)
ProcessTyp = "typical/cen28hpl_1p09m+16kalrdl_4x2y2r_typical.nxtgrd"
ProcessWst = "rcworst/cen28hpl_1p09m+16kalrdl_4x2y2r_rcworst.nxtgrd"
ProcessAll = {'typ': ProcessTyp, 'wst': ProcessWst, 'other': 'other'}

# Temperature - do not change
TemperWst = 170
TemperTyp = 25
TemperAll = {'typ': TemperTyp, 'wst': TemperWst, 'other': 'other'}

# Declare master run file & master tech file
#hsscP2PRun = "/design04/u2a8_bed2_vf/u2a8/data/u2a8/5_layout/COMMON_PL/09_hssc/run_hssc.cmd"
#hsscP2PTech = "/design04/u2a8_bed2_vf/u2a8/data/u2a8/5_layout/COMMON_PL/09_hssc/hssc.tech_RV28F"
hsscP2PRun  = r'D:\HSSC\run_hssc.cmd'
hsscP2PTech = r'D:\HSSC\hssc.tech_RV28F'

#######################
# Parameter level tech file
# Declare GDS/Power and Ground
# hsscP2PListNet      = ['ISOVDD', 'VSS', 'AWOVDD', 'SYSVCC', 'VCC', 'OTHERS']
# Declare ListNet as a dictionary to store power name
ListNet = {0: 'ISOVDD', 1: 'VSS', 2: 'AWOVDD', 3: 'SYSVCC', 4: 'VCC', 'other': 'OTHERS'}
# In U2A8, these power has a large interconnect PG mesh
# they need a specifice GDS to reduce TAT
hsscp2pGDSOther = "/design04/u2a8_bed2_vf/u2a8/usr/hauhuynh/PV/wrappers/f5689_1114/01_gdsmerge_multi/191014_01/01_gdsmerge_01__BLOCK001/results/R7F702301_PR_f5689_1114_191014_01.STR.gz"
hsscp2pGDSAWO = "/design04/u2a8_bed2_vf/u2a8/usr/hauhuynh/PV/wrappers/f5689_1114/01_gdsmerge_multi/191014_01/01_gdsmerge_01__BLOCK002/results/R7F702301_PR_f5689_1114_191014_01.STR.gz"
hsscp2pGDSVSS = "/design04/u2a8_bed2_vf/u2a8/usr/hauhuynh/PV/wrappers/f5689_1114/01_gdsmerge_multi/191014_02/01_gdsmerge_01__BLOCK001/results/R7F702301_PR_f5689_1114_191014_02.STR.gz"
hsscp2pGDSISO = "/design04/u2a8_bed2_vf/u2a8/usr/hauhuynh/PV/wrappers/f5689_1114/01_gdsmerge_multi/191014_02/01_gdsmerge_01__BLOCK002/results/R7F702301_PR_f5689_1114_191014_02.STR.gz"
hsscp2pGDSSYS = "/design04/u2a8_bed2_vf/u2a8/usr/hauhuynh/PV/wrappers/f5689_1114/01_gdsmerge_multi/191014_02/01_gdsmerge_01__BLOCK003/results/R7F702301_PR_f5689_1114_191014_02.STR.gz"
hsscp2pGDSVCC = "/design04/u2a8_bed2_vf/u2a8/usr/hauhuynh/PV/wrappers/f5689_1114/01_gdsmerge_multi/191014_02/01_gdsmerge_01__BLOCK004/results/R7F702301_PR_f5689_1114_191014_02.STR.gz"
# Declare GDSAll as a dictionary to strow 2 dimension varibales
GDSAll = {ListNet[0]: hsscp2pGDSISO, ListNet[1]: hsscp2pGDSVSS, ListNet[2]: hsscp2pGDSAWO, ListNet[3]: hsscp2pGDSSYS,
          ListNet[4]: hsscp2pGDSVCC, ListNet['other']: hsscp2pGDSOther}

# RUN MODE #
case_w_w = 1
case_w_t = 1
case_t_w = 1

#######################
# Parameter level run file
# Default memory and cpu
mem = 96000
memALL = 96000;
cpuALL = 4
memVSS = 128000;
cpuVSS = 4
memISO = 96000;
cpuISO = 4
memSYS = 96000;
cpuSYS = 4
memVCC = 64000;
cpuVCC = 2
memAWO = 64000;
cpuAWO = 2
memAll = {ListNet[0]: memISO, ListNet[1]: memVSS, ListNet[2]: memAWO, ListNet[3]: memSYS, ListNet[4]: memVCC,
          ListNet['other']: memALL, '1': 32000, '2': 196000}
cpuAll = {ListNet[0]: cpuISO, ListNet[1]: cpuVSS, ListNet[2]: cpuAWO, ListNet[3]: cpuSYS, ListNet[4]: cpuVCC,
          ListNet['other']: cpuALL, '1': 6, '2': 8}
# cpuAll  = {'ISOVDD':cpuISO,  'VSS':cpuVSS, 'AWOVDD':cpuAWO, 'SYSVCC':cpuSYS, 'VCC':cpuVCC, 'OTHERS':cpuALL, '1': 6, '2':8}


# Parameter regards to list of probe node info
# Syntax: probe net_name x1 y1 lay1 x2 y2 lay2
hsscP2PProbe = {}
my_dict_2d(hsscP2PProbe, 'wst', 'wst', "./probe_w_w.txt")
my_dict_2d(hsscP2PProbe, 'wst', 'typ', "./probe_w_t.txt")
my_dict_2d(hsscP2PProbe, 'typ', 'wst', "./probe_t_w.txt")
# my_probe_dir_generator ( cell_name, process, temper, list_net, run_file, tech_file, probe_file, layouttext_file, probe_key, layouttext_key)
if __name__ == "__main__":
  my_probe_dir_generator(hsscP2PProduct, 'wst', 'wst', ListNet, hsscP2PRun, hsscP2PTech, hsscP2PProbe['wst']['wst'], '','### PROBE', '')
