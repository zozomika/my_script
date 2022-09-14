#!/bin/csh -f

#./ExportSilkPortalData.py   # Export to MonthlyAttendanceReport.html

dos2unix MonthlyAttendanceReport.html

set begin_line = `grep -n " Datagrid " MonthlyAttendanceReport.html | cut -d':' -f1 | head -1`
set end_line   = `grep -n " Datagrid " MonthlyAttendanceReport.html | cut -d':' -f1 | tail -1`

set datagrid = "datagrid.html"
sed -n ''$begin_line','$end_line'p' MonthlyAttendanceReport.html >! $datagrid
sed -n ''2','10'p' MonthlyAttendanceReport.html >! $datagrid

foreach line ("`cat $datagrid`")
  if (`echo "$line" | grep "Full paid leave" | wc -l` == 1) then
    set fpl = 1
    set chomped_line = `echo "$line" | sed 's/<[^>]*>/ /g' | tr -d "\t" | sed 's/  */ /g'`
    set data = `echo "$chomped_line" | awk '{print $NF}'`
  endif
  if (`echo "$line" | grep "UnPaid leave" | wc -l` == 1) then
    set fpl = 0
    set chomped_line = `echo "$line" | sed 's/<[^>]*>/ /g' | tr -d "\t" | sed 's/  */ /g'`
    set data = `echo "$chomped_line" | awk '{print $NF}'`
  endif

  if (`echo "$line" | grep "Leave Type" | wc -l` == 1) then
    set chomped_line = `echo "$line" | sed 's/<[^>]*>/ /g' | tr -d "\t" | sed 's/  */ /g'`
    if ($fpl == 1) then
      printf "Full paid leave: $data day(s) \t $chomped_line\n"
    else
      printf "   UnPaid leave: $data day(s) \t $chomped_line\n"
    endif
  endif
end

