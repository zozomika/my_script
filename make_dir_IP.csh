#!/bin/csh  -xf

set list_DIR = ( VIO VDC 3DG MM IR HSC RT MP PERE PERW CC CA52 CA57 )  
set num = 1   

foreach DIR ($list_DIR)  
  if ($num < 10 ) then    
      mkdir "0"${num}"_"${DIR}   
      @  num = $num + 1
  else 
      mkdir ${num}"_"${DIR}  
      @  num = $num + 1
  endif 
end
