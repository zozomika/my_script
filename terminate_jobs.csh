#!/bin/csh -f

set me=`whoami`

#sleep 3600

bjobs -u $me | grep -i gui | awk '{print $1}' | xargs bkill -r

echo "$me, your jobs has been killed. Sorry"

