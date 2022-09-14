#!/bin/csh -f

set email_list = 'hau.huynh.ry@rvc.renesas.com'
touch message
while (1) 
    set a = `date +%H\ %M\ %S | awk '{print $1" "$2" "$3}'`
    # GUI will be terminated at 23PM
    if($a[1] == "11" && $a[2] == "02") then
        set gui_job = `bjobs | grep -i GUI | egrep "login01|login09" | awk '{print $1}'`
          if ($gui_job[1] == "") then
              printf " No Gui Job" 
              #mailx -s "Remind Gui Job Execution" $email_list < message
              #rm -rf message
          else
            echo " Are you here? All Gui jobs will be terminated afer 15 minutes\
 Please turn-off kill_jobs script if you continue to use Gui then restart it later" >> message
            echo " Gui jobs are executing: " >> message
            echo `bjobs | grep -i GUI | egrep "login01|login09"` >>  message
## send email command
            mailx -s "Remind Gui Job Execution" $email_list < message
            rm -rf message
            touch message
            sleep 001s
            foreach job ($gui_job)
                bkill $job
            end
            printf " All GUI jobs are terminated" >> message
            mailx -s "Remind GUI Execution" $email_list < message
            rm -rf message
        endif
    endif
    sleep 59s
end    

