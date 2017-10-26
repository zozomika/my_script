#!/usr/bin/python
import sys, re
## Input declaration
rpt_1 = sys.argv[1]
input = open(rpt_1, 'r')

## Output declaration
output_file = rpt_1.split('.')[0] + '.ploc'
list = input.readlines()

output = open(output_file, 'w')
## param
map_layer = {}
#output = open(output_file, 'w')
for line in list:
    line  = line.strip()
    if len(line) > 1:
       line_arr = line.split()
       if line_arr[0] == 'GDS_MAP_FILE': 
           map_file = open(line_arr[1], 'r')
           map_lst = map_file.readlines()
           for map_line in map_lst:
                if (len(map_line.split())==4 and len(map_line.split()[0]) >1):
                        layer = map_line.split()[0]
                        num = map_line.split()[2]
                        if len(num) == 4: num = num + '0'
                        map_layer[num] = layer
for line in list:
    line  = line.strip()
    if len(line) > 1:
       line_arr = line.split()
       if len(line_arr) > 4:
          if (line_arr[1] == '@' and line_arr[0][0] != '#'):
                if re.match (r"^\VSS+.*$",line_arr[0]):
                        output.write("%s %s %s %s %s \n" %(line_arr[0], line_arr[3], line_arr[4], map_layer[line_arr[2]], 'GROUND'))
                else:
                        output.write("%s %s %s %s %s \n" %(line_arr[0], line_arr[3], line_arr[4], map_layer[line_arr[2]], 'POWER'))
output.close()
map_file.close()
                
             
    #if len(line_arr) > 4:
    #    str = line_arr[1]
    #    print str
                #output.write(line)
