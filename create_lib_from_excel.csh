#!/bin/csh -f


### COMMON SETTING ########################################################################################################

set file = $1 # input lib from excel file
set mode = $2 # -cdl or -gds or -nwpg
dos2unix $1
set DATE  = `date '+%y%m%d_%H%M'`

### EXECUTED COMMAND ######################################################################################################
#### CDL ####
if ("$mode" == "-cdl" ) then
 set output_file = "fr_Library_sheet${mode}_${DATE}.txt"
 foreach line  (`cat $file`)
  foreach leaf_file  (`tree -fi --noreport $line | awk '((/.spi$/)||(/.cdl$/)||(/error/)||(/source.added/)){print $1}'`)
   #set cdl_file = `echo $leaf_file | sed 's/\/\//\//' |sort -u` 
   set cdl_file = `echo $leaf_file | sed 's/\/\//\//' |sort -u` 
   echo $cdl_file   >> $output_file
  end
 end
cat $output_file | sort -u > fr_Library_sheet${mode}_${DATE}.txt_sorted

### GDS ###
else if ("$mode" == "-gds") then
 set output_file = "fr_Library_sheet.{$mode}_${DATE}.txt"
 foreach line  (`cat $file`)         
  foreach leaf_file  (`tree -fi --noreport $line | awk '((/.gds$/)||(/error/)||(/gds_dm$/)||(/gds.gz$/)){print $1}'`)
   set gds_file = `echo $leaf_file | sed 's/\/\//\//g'  | grep -v ".txt"`
    echo $gds_file >> $output_file
  end
 end
cat $output_file | sort -u  | awk '{if ($0 !~/^$/) {print}}' > fr_Library_sheet{$mode}_${DATE}.txt_sorted
else if ("$mode" == "-nwpg") then
set output_file = "fr_Library_sheet.{$mode}_${DATE}.txt"
 foreach line  (`cat $file`)          
  foreach leaf_file  (`tree -fi --noreport $line | awk '((/.nw$/)||(/error/)){print $1}'`)
   set gds_file = `echo $leaf_file | sed 's/\/\//\//g' `
    echo $gds_file >> $output_file
  end                 
 end                  
cat $output_file | sort -u  | awk '{if ($0 !~/^$/) {print}}' > fr_Library_sheet{$mode}_${DATE}.txt_sorted
endif

### EOF ##################################################################################################################
