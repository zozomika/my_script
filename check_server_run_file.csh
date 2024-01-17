#!/bin/csh -f
#------------------------------------------------------------------
# Syntax        : vdedi_sever.csh <list_of_calibre_server>
#		: if you don't define <list_of_calibre_server>, the sever defined in this script ("list_server") will be check
# Function      : summary status of submited jobs on dedicated server about: "Job_ID","Job_Name","Status(RUN/PEND)","HostSpecified","Host_runing","Submited_time","Started_time","Mem","User"
# By        	: Hoai Tran
# Updated       : Hac Nguyen
# History	: 20101124 : new creation
#-------------------------------------------------------------------
if ($#argv == 0) then
    set user = `whoami`
    echo "$user"
else 
    set user = "$argv[1]"
endif
#set user = `whoami`

if (`hostname` =~ *login*) then
   #if ( $#argv == 0) then
      set DEDI = `grep -e $user /common/lsftool/RBS/attrib/SP_HOSTS_DIR/* | awk -F '/|:' '{print $(NF-1)}'`
      set DEDI = ""
      foreach dedi_name ($DEDI)
         echo "$dedi_name "DEDICATED"" >> $PWD/dedicated_list
      end
      set list_server_MENTOR = `bmgroup -w | grep HOSTGR_MENTOR | sed 's/HOSTGR_MENTOR//g'`
      set list_server_select = `awk '{printf $1" "}' $PWD/dedicated_list`
      echo "$list_server_select $list_server_MENTOR "  >! $PWD/total_server.list
      set list_server =  `awk '{printf $0" "}' $PWD/total_server.list`
   #else
      #set list_server = "$argv[1-$#argv]"
   #endif
   awk 'BEGIN { \
      print "========================================================================================================================================="; \
      printf ("%-18s%-10s%-60s%-12s%8s%8s%18s\n",\
      "User","Job_ID","Job_Name","Host_runing","Mem","CPU","Started_time"); \
   }'
   bhosts -s use_mem_size | awk '{print $2, $3, $4}' >! $PWD/mem_total
   bhosts HOSTGR_MENTOR | awk '{print $1, $4-$5}' >! $PWD/cpu_total
   bhosts $list_server_select | awk '{print $1, $4-$5}' >! $PWD/dedi_total

# MN 2012/07/05
#   lshosts | grep -v "HOST_NAME" | \
#   awk '{ 	gsub (/M/,"",$6); mem = int ($6/1000) \
#      print $1"\t\t" $5 \
#   }' >! $home/dedi_total
# end MN 2012/07/05
   foreach server ( $list_server )
      if ( $server != "" ) then
         set remain_CPU_dedi   = `awk '{ if ($1 == "'$server'") print $2 }' $PWD/dedi_total`
         set reserved_mem      = `awk '{ if ($3 == "'$server'") print $2 }' $PWD/mem_total`
         set remain_CPU_MENTOR = `awk '{ if ($1 == "'$server'") print $2 }' $PWD/cpu_total`
         if ($remain_CPU_MENTOR =="") then
            set remain_CPU = $remain_CPU_dedi
         else 
            set remain_CPU = $remain_CPU_MENTOR
         endif
         set remain_mem  = `awk '{ if ($3 == "'$server'") print $1 }' $PWD/mem_total`
         echo "=========================================================================================================================================";

         sjobs -u all -l -m $server | sed -e 's/^ *//g' -e 's/</ /g' -e 's/>/ /g' | perl -p -i -e 's/from host/\n/g' \
         | awk '{if($0!~/Submitted/){printf $0} else {print "\n"$0}}' | perl -p -i -e 's/,/\n/g' | perl -p -i -e 's/;/\n/g' | perl -p -i -e 's/PARAMETERS/\n/g' | awk ' \
         BEGIN { \
            Job_ID 		= "-"; \
            Job_Name 		= "-"; \
            User			= "-"; \
            Status 		= "-"; \
            HostSpecified = "-"; \
            Host_runing   = "-"; \
            Submited_time = "-"; \
            Started_time 	= "-"; \
            Mem 			= "-"; \
            CPU           = 1; \
            Reserved_MEM  = '$reserved_mem' \
            Remain_MEM	= '$remain_mem' \
            Remain_CPU	= '$remain_CPU' \
            Remain_CPU_   = '$remain_CPU'	\
            while (getline<"./dedicated_list") {PJ[$1]=$2} \
         } \
         { \
         	if ($0 ~ /Job *[0-9][0-9]*/) {Job_ID = $NF} else \
            if ($0 ~ /Job Name/) {Job_Name = $3; if (length(Job_Name)>50) {Job_Name = substr($3,0,50)}} else \
            if ($0 ~ /User/ && ($0 !~ /\//)) {User = $2} else \
            if ($0 ~ /Status/) {Status = $2} else \
            if ($0 ~ /use_mem_size=/) {sub(/.*=/,"",$0); Mem= $0; Reserved_MEM = Reserved_MEM; Remain_CPU = Remain_CPU - 1} else \
            if ($0 ~ /Submitted/) {Submited_time=$2"/"$3"/"$4} else \
         	if ($0 ~ /Specified Hosts/ || $0 ~ /SpecifiedHosts/) {HostSpecified = $NF} else \
         	if ($0 ~ /Processors Requested/) { CPU = $1; Remain_CPU = Remain_CPU - CPU + 1 } else \
         	if ($0 ~ /Started on/ && Status=="RUN") {Host_runing = $NF; Started_time=$2"/"$3"/"$4;} \
         	if ($0 ~ /SCHEDULING/) { \
         	   printf ("%-18s%-10s%-60s%10s%9s%8s%21s\n",\
               User,Job_ID,Job_Name,Host_runing,Mem"G",CPU"CPU",Started_time); \
         	   CPU                     = 1; \
            } \
         } \
         END {printf "%88s%5s%10s%8s%-10s\n","->Remain_memory / Remain_CPU : ","'$server'",Remain_MEM"G ",Remain_CPU_"CPU "," Priority: "PJ["'$server'"] >> ENVIRON["PWD"]"/check_calibre_server.log"}'
      endif
   end
   exit 
else
   echo "This script only run in login LSF system; please check if you have login LSF."
   exit 
endif
