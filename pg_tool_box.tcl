#######################################                                                                                                                                     
## AUTHOR  :  HauHuynh-BE3           ##
## DATE    :  26/01/2018             ##
## PURPOSE :  PG ROUTING GUI         ##
## Updated :  Jul/26/18 Adding more  ##
##            bugs to fix later      ##
#######################################

#source /design04/u2a16_bed2_vf/u2a16/usr/hauhuynh/Common/proc_icc2_3.tcl
###   INITITAL     ### create window: w_0
destroy        .topMenu_makepg
set       w_0  .topMenu_makepg
toplevel  $w_0 -borderwidth 8
wm title  $w_0 "PG ROUTING TOOL BOX"

###  COMMON DEFINE ### main frame: frame1, subframe: frame1.hard, frame1.partial
frame $w_0.frame1                                              -borderwidth 2 -relief groove 
frame $w_0.frame1.hard                                         -borderwidth 0 -relief groove
frame $w_0.frame1.partial                                      -borderwidth 0 -relief groove
###      FRAME1    ###  
label  $w_0.frame1.name                                        -text "#1 Create PG as Pin Shape"  
label  $w_0.frame1.hard.type                                   -text "Select layer"               -width 10
button $w_0.frame1.hard.mode_macro                             -text "Select Pin name"            -width 14 -borderwidth 2 -command {puts "Selecting $pin_sel"; gpin $pin_sel } -justify left
button $w_0.frame1.hard.create                                 -text "Pin shape"  -borderwidth 2  -width  8 -command  { puts "Create PG $metal_lay strap same as $pin_lay pin $pin_sel"; gpinshape $pin_lay $metal_lay $pin_sel }
label  $w_0.frame1.hard.ver                                    -text "Pin Layer"                  -width 10
label  $w_0.frame1.hard.hoz                                    -text "Metal Layer"                -width 10
entry  $w_0.frame1.hard.mode_macro_in                          -textvariable pin_sel              -width 16 -borderwidth 2
ttk::combobox    $w_0.frame1.hard.ver_in                       -textvariable pin_lay   -values [list M1 M2 M3 M4 M5 M6 M7 M8 M9 AP] -width 10
ttk::combobox    $w_0.frame1.hard.hoz_in                       -textvariable metal_lay -values [list M1 M2 M3 M4 M5 M6 M7 M8 M9 AP] -width 10


label  $w_0.frame1.partial.name                                -text "Default layer"              -width 11 
button $w_0.frame1.partial.create_metal_pin                    -text "Pin shape"  -borderwidth 2  -width 10 -command  { puts "Create PG same as pin"; gpinshape2 } 
#entry  $w_0.frame1.hard.ver_in                                 -textvariable ver -width 14
#label  $w_0.frame1.hard.space                                  -text "hihi" -width 8
#radiobutton $w_0.frame1.hard.mode_sel                          -text "select" -selectcolor yellow -variable sel -value 1  -state active -width 5    

###     DISPLAY    ###
grid   $w_0.frame1                                                         -row 0 -column 0 -sticky n
grid   $w_0.frame1.hard                        -in $w_0.frame1             -row 1 -column 0 -sticky news
grid   $w_0.frame1.partial                     -in $w_0.frame1             -row 2 -column 0 -sticky news
grid   $w_0.frame1.name                        -in $w_0.frame1             -row 0 -column 0 -sticky w 
grid   $w_0.frame1.partial                     -in $w_0.frame1             -row 2 -column 0 -sticky news
grid   $w_0.frame1.hard.type                   -in $w_0.frame1.hard        -row 1 -column 0 -sticky w
grid   $w_0.frame1.hard.ver                    -in $w_0.frame1.hard        -row 1 -column 1 -sticky w
grid   $w_0.frame1.hard.ver_in                 -in $w_0.frame1.hard        -row 2 -column 1 -sticky w
grid   $w_0.frame1.hard.hoz                    -in $w_0.frame1.hard        -row 1 -column 2 -sticky w
grid   $w_0.frame1.hard.hoz_in                 -in $w_0.frame1.hard        -row 2 -column 2 -sticky w
#grid   $w_0.frame1.hard.space                  -in $w_0.frame1.hard        -row 2 -column 3 -sticky w
grid   $w_0.frame1.hard.mode_macro             -in $w_0.frame1.hard        -row 1 -column 3 -sticky w
grid   $w_0.frame1.hard.mode_macro_in          -in $w_0.frame1.hard        -row 2 -column 3 -sticky w
#grid   $w_0.frame1.hard.mode_sel               -in $w_0.frame1.hard        -row 1 -column 4 -sticky w
grid   $w_0.frame1.hard.create                 -in $w_0.frame1.hard        -row 1 -column 4 -sticky w 

grid   $w_0.frame1.partial.name                -in $w_0.frame1.partial     -row 0 -column 0 -sticky w  
grid   $w_0.frame1.partial.create_metal_pin    -in $w_0.frame1.partial     -row 1 -column 0 -sticky w  

#--------------------------------------------------------------------------------------------------------------------------
###      FRAME2    ###  
frame  $w_0.frame2                                             -borderwidth 2 -relief groove  
frame  $w_0.frame2.move                                        -borderwidth 1 -relief groove
frame  $w_0.frame2.copy                                        -borderwidth 1 -relief groove

###      ----- For moving  ###
label  $w_0.frame2.name                                        -text "#2 Adjust PG STRAP/PG VIA" 
button $w_0.frame2.move.lef                                    -text "Move x"  -borderwidth 2 -width 6 -command {puts "move $_mhor um"; gmovex $_mhor}
entry  $w_0.frame2.move.entrylef                               -textvariable _mhor            -width 8
#label  $w_0.frame2.move.entrylef_name                          -text "um"                   -width 4
button $w_0.frame2.move.rig                                    -text "Move y" -borderwidth 2  -width 6 -command {puts "move $_mver um"; gmovey $_mver}
entry  $w_0.frame2.move.entryrig                               -textvariable _mver            -width 8
#label  $w_0.frame2.move.entryrig_name                          -text "um"                   -width 4
button $w_0.frame2.move.both                                   -text "Move x,y" -borderwidth 2 -width 8 -command {puts "move $_mhor, $_mver"; gmove $_mhor $_mver}
label  $w_0.frame2.move.note                                   -text "<x,y: um>" -width 10

###      ----- For copying ###
button $w_0.frame2.copy.lef                                    -text "Copy x"  -borderwidth 2 -width 6 -command {puts "Copy to $_chor um"; gcopyx $_chor}
entry  $w_0.frame2.copy.entrylef                               -textvariable _chor            -width 8
#label  $w_0.frame2.copy.entrylef_name                          -text "x um"                   -width 4
button $w_0.frame2.copy.rig                                    -text "Copy y"  -borderwidth 2 -width 6 -command {puts "Copy to $_cver um"; gcopyy $_cver}
entry  $w_0.frame2.copy.entryrig                               -textvariable _cver            -width 8
#label  $w_0.frame2.copy.entryrig_name                          -text "x um"                   -width 4
button $w_0.frame2.copy.both                                   -text "Copy x,y" -borderwidth 2 -width 8 -command {puts "Copy to $_chor, $_cver"; gcopy $_chor $_cver}
label  $w_0.frame2.copy.note                                   -text "<x,y: um>" -width 10


###     DISPLAY    ###
grid   $w_0.frame2                                               -row 3 -column 0 -sticky news -pady 10
grid   $w_0.frame2.name               -in $w_0.frame2            -row 0 -column 0 -sticky w
grid   $w_0.frame2.move               -in $w_0.frame2            -row 1 -column 0 -sticky news -pady 10
grid   $w_0.frame2.move.lef           -in $w_0.frame2.move       -row 0 -column 1 -sticky w
grid   $w_0.frame2.move.entrylef      -in $w_0.frame2.move       -row 1 -column 1 -sticky w
#grid   $w_0.frame2.move.entrylef_name -in $w_0.frame2.move       -row 1 -column 0 -sticky w
grid   $w_0.frame2.move.rig           -in $w_0.frame2.move       -row 0 -column 3 -sticky w 
grid   $w_0.frame2.move.entryrig      -in $w_0.frame2.move       -row 1 -column 3 -sticky w 
#grid   $w_0.frame2.move.entryrig_name -in $w_0.frame2.move       -row 1 -column 2 -sticky w 
grid   $w_0.frame2.move.both          -in $w_0.frame2.move       -row 0 -column 4 -sticky w 
grid   $w_0.frame2.move.note          -in $w_0.frame2.move       -row 1 -column 4 -sticky w 
#grid   $w_0.frame2.move.active       -in $w_0.frame2.move        -row 3 -column 0 -sticky w 

grid   $w_0.frame2.copy              -in $w_0.frame2             -row 1 -column 1 -sticky news -padx 20 -pady 10
grid   $w_0.frame2.copy.lef          -in $w_0.frame2.copy        -row 0 -column 0 -sticky w
grid   $w_0.frame2.copy.entrylef     -in $w_0.frame2.copy        -row 1 -column 0 -sticky w
grid   $w_0.frame2.copy.rig          -in $w_0.frame2.copy        -row 0 -column 1 -sticky w 
grid   $w_0.frame2.copy.entryrig     -in $w_0.frame2.copy        -row 1 -column 1 -sticky w 
grid   $w_0.frame2.copy.both         -in $w_0.frame2.copy        -row 0 -column 2 -sticky w 
grid   $w_0.frame2.copy.note         -in $w_0.frame2.copy        -row 1 -column 2 -sticky w
#--------------------------------------------------------------------------------------------------------------------------
###      FRAME3    ###  
frame  $w_0.frame3                                             -borderwidth 2 -relief groove  
frame  $w_0.frame3.via                                         -borderwidth 0 -relief groove 
frame  $w_0.frame3.make_port                                   -borderwidth 0 -relief groove


###      ----- For editting ###
label  $w_0.frame3.via.increase_via_lab                        -text "Via Size"  -width 6    -font {Calibri 12  }
button $w_0.frame3.via.increase_via_lef                        -text " - "      -width 2    -borderwidth 2 -command    {puts "Decrease via's column 1 unit" ; gui_change_via_size -via [get_vias [get_selection ]] -rows [get_attribute [get_selection  ] number_of_rows] -columns [expr [get_attribute [get_selection  ] number_of_columns]-1]}
button $w_0.frame3.via.increase_via_rig                        -text " + "      -width 2    -borderwidth 2 -command    {puts "Increase via's column 1 unit"; gui_change_via_size -via [get_vias [get_selection ]] -rows [get_attribute [get_selection  ] number_of_rows] -columns [expr [get_attribute [get_selection  ] number_of_columns]+1]}
button $w_0.frame3.via.increase_via_top                        -text " + "      -width 4    -borderwidth 2 -command    {puts "Increase via's row 1 unit"  ; gui_change_via_size -via [get_vias [get_selection ]] -rows [expr [get_attribute [get_selection  ] number_of_rows]+1] -columns [get_attribute [get_selection  ] number_of_columns]}
button $w_0.frame3.via.increase_via_bot                        -text " - "      -width 4    -borderwidth 2 -command    {puts "Decrease via's row 1 unit";gui_change_via_size -via [get_vias [get_selection ]] -rows [expr [get_attribute [get_selection  ] number_of_rows]-1] -columns [get_attribute [get_selection  ] number_of_columns]}
ttk::combobox    $w_0.frame3.via.copy_entrylay                 -textvariable _clay          -values [list M1 M2 M3 M4 M5 M6 M7 M8 M9 AP]  -width 10
button $w_0.frame3.via.create                                  -text "Create Via"   -borderwidth 2 -width 10 -command  {puts "Create PG VIA..."; gv $_clay}
button $w_0.frame3.via.copy_lay                                -text "Copy Layer"   -borderwidth 2 -width 10 -command  {puts "Copy selected object to $_clay layer"; gcoppy_layer $_clay}
button $w_0.frame3.via.change_lay                              -text "Change Layer" -borderwidth 2 -width 10 -command  {puts "Change selected object to $_clay layer"; glay $_clay}
ttk::combobox    $w_0.frame3.via.entry_shape_use               -textvariable _shape_use      -values [list area_fill core_wire detail_route follow_pin global_route lib_cell_pin_connect macro_pin_connect opc ring shield_route stripe user_route zero_skew]  -width 10 
button $w_0.frame3.via.shape_use_strap                         -text "Change Metal"   -borderwidth 2 -width 10 -command  {if {$_shape_use!=""} {puts "Change attribute: $_shape_use"; gchange_shape_use_of_shape $_shape_use} else {puts "Please import shape_use"}} 
button $w_0.frame3.via.shape_use_via                           -text "Change Via"     -borderwidth 2 -width 10 -command  {if {$_shape_use!=""} {puts "Change attribute: $_shape_use"; gchange_shape_use_of_vias  $_shape_use} else {puts "Please import shape_use"}}
entry  $w_0.frame3.via.entry_rename                            -textvariable _rename                 -width 14 
button $w_0.frame3.via.rename_strap                            -text "Rename Metal"   -borderwidth 2 -width 12 -command  {if {$_rename!=""} {puts "Change to net: $_rename"; gchange_net_name_shape $_rename   } else {puts "Please import net name"}} 
button $w_0.frame3.via.rename_via                              -text "Rename Via"     -borderwidth 2 -width 12 -command  {if {$_rename!=""} {puts "Change to net: $_rename"; gchange_net_name_via  $_rename} else {puts "Please import net name"}}
#button $w_0.frame2.via.pin_fr_pin                              -text "ARRANGE PIN from PIN" -borderwidth 2 -width 10 -command {arrange_connected_neighbor_pins_from_selected_pins}

label  $w_0.frame3.make_port.name                              -text "** MAKE PORTS **"
button $w_0.frame3.make_port.exit                              -text "EXIT"     -width 4    -borderwidth 2 -command { destroy $w_0} -foreground red 


###     DISPLAY    ###
grid   $w_0.frame3                                                        -row 4 -column 0 -sticky news
grid   $w_0.frame3.via                        -in $w_0.frame3             -row 3 -column 0 -sticky news
grid   $w_0.frame3.via.increase_via_lab       -in $w_0.frame3.via         -row 2 -column 1 -sticky w -pady 5
grid   $w_0.frame3.via.increase_via_lef       -in $w_0.frame3.via         -row 2 -column 0 -sticky w
grid   $w_0.frame3.via.increase_via_rig       -in $w_0.frame3.via         -row 2 -column 2 -sticky w
grid   $w_0.frame3.via.increase_via_top       -in $w_0.frame3.via         -row 1 -column 1 -sticky w
grid   $w_0.frame3.via.increase_via_bot       -in $w_0.frame3.via         -row 3 -column 1 -sticky w
grid   $w_0.frame3.via.copy_entrylay          -in $w_0.frame3.via         -row 1 -column 4 -sticky w -padx 10
grid   $w_0.frame3.via.copy_lay               -in $w_0.frame3.via         -row 2 -column 4 -sticky w -padx 10
grid   $w_0.frame3.via.create                 -in $w_0.frame3.via         -row 3 -column 4 -sticky w -padx 10
grid   $w_0.frame3.via.change_lay             -in $w_0.frame3.via         -row 4 -column 4 -sticky w -padx 10
grid   $w_0.frame3.via.entry_shape_use        -in $w_0.frame3.via         -row 1 -column 5 -sticky w  
grid   $w_0.frame3.via.shape_use_strap        -in $w_0.frame3.via         -row 2 -column 5 -sticky w  
grid   $w_0.frame3.via.shape_use_via          -in $w_0.frame3.via         -row 3 -column 5 -sticky w  
grid   $w_0.frame3.via.entry_rename           -in $w_0.frame3.via         -row 1 -column 6 -sticky w -padx 10
grid   $w_0.frame3.via.rename_strap           -in $w_0.frame3.via         -row 2 -column 6 -sticky w -padx 10 
grid   $w_0.frame3.via.rename_via             -in $w_0.frame3.via         -row 3 -column 6 -sticky w -padx 10
#grid   $w_0.frame2.via.pin_fr_pin   -in $w_0.frame2.via         -row 0 -column 2 -sticky w

grid   $w_0.frame3.make_port         -in $w_0.frame3             -row 5 -column 0 -sticky w
grid   $w_0.frame3.make_port.exit    -in $w_0.frame3.make_port   -row 5 -column 3 -sticky w 

###    RESET BOX   ###
$w_0.frame1.hard.ver_in    delete 0 end
$w_0.frame1.hard.hoz_in    delete 0 end

