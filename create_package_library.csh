#!/bin/csh -f
set DATE  = `date '+%y%m%d_%H%M'`
set input = "CN_Rev014_171030"
set product = (gdsmerge_cntl_src lib.nwcell__hier_src cdllist nw_nonPG_src leffile_src)

if (-d ./LIB ) then
        echo "LIB directory already made... it will be removed, please re-run"
        rm -rf ./LIB
else 
        mkdir ./LIB
        cp -rf $input ./LIB
        echo "cp -rf $input ./LIB"
        while ($#product)
                set target = "$product[1]"
                echo "$target"
                if (-e $target) then
                        cp -rf $target ./LIB
                        echo "cp -rf $target ./LIB"
                endif
                shift product
        end
        tar -cjf ./to_REL_RCarE3_${input}.tar.bz2 ./LIB
endif

#setenv output to_REL_RCarE3_${input}.tar
#source ./send.csh

