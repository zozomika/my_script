#!/bin/csh
setenv DATE `date '+%y%m%d_%H%M'`
setenv user `whoami`
#import -window root -crop 1366x668+000+50 -quality 100 /common/work/${user}/screenshot_${DATE}.png -trim 
import -window root -crop 3286x1200 -quality 100 /common/work/${user}/screenshot_${DATE}.png -trim 
#import -window root -crop 1366x668+000+50 -quality 100 /common/work/haulamhuynh/screenshot_${DATE}.png -trim 
