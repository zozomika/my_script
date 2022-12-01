#source /home/u/thanhhainguyen/thanh/script/ICC2/icc2_hot_key.tcl
#source /design04/u2a16_bed2_vf/u2a16/usr/hauhuynh/Common/shape_extend_4_cross3.tcl
source ~/script/Common/shape_extend_4_cross3.tcl
#source /design04/u2a16_bed2_vf/u2a16/usr/hauhuynh/Common/hot_key.tcl
source ~/script/Common/hot_key.tcl


#source /shsv/PnR/P2F2_EVA/4.DESIGN/TRIAL/WORK_HAULAMHUYNH/06_P2F2_EVA/01_PG/scripts/routing/make_pattern.tcl
proc gpgtool {} { source ~/script/Common/pg_tool_box.tcl}
#To change colour M9
#gui_set_layout_layer_visibility -toggle [get_layers -filter {mask_name == metal9} -quiet]
#set_snap_setting -class {std_cell} -snap {litho}
#set_snap_setting -class {metal_shape} -snap {litho}
#set_snap_setting -class {placement_constraint} -snap {litho}
#set_snap_setting -class {wiring_constraint} -snap {litho}
#To turn on snap setting
gui_set_hotkey -hot_key "Ctrl + S" -replace -tcl_cmd {set_snap_setting -enabled {true}}
#Making via for list pin which has common connection
#proc gpinshape { metal_pin metal_layer list_pin } {
#   foreach EACH_PORT $list_pin {
#      set net_shape [get_attribute [get_nets -of [get_pins $EACH_PORT] -phy] name]
#      foreach_in_collection metal_pin_shape [get_shapes -of_objects [get_pins -physical_context  $EACH_PORT] -filter layer.name==$metal_pin ] {
#         set poly_pin [split_polygons -objects $metal_pin_shape -output poly_rect]
#            foreach_in_collection shape_i $poly_pin {
#               set box     [get_attribute -quiet  $shape_i bbox]
#               if { $box   != ""} {
#                  set box_llx [lindex [lindex $box 0] 0]
#                  set box_lly [lindex [lindex $box 0] 1]
#                  set box_urx [lindex [lindex $box 1] 0]
#                  set box_ury [lindex [lindex $box 1] 1]
#                  set width  [expr abs ( $box_urx - $box_llx)]
#                  set length [expr abs ( $box_lly - $box_ury)]
#                  if { $width  < $length} {
#                    set is_vertical 1
#                    set llx_path [ expr $box_llx + ( $width * 0.5 ) ]
#                    create_shape -shape_type path -layer $metal_layer -path  [subst {{$llx_path $box_lly} {$llx_path $box_ury}}] -net $net_shape  -width $width -shape_use core_wire
#                  } else {
#                    set is_vertical 0
#                    set lly_path [ expr $box_lly + ( $length * 0.5 ) ]
#                    create_shape -shape_type path -layer $metal_layer -path  [subst {{$box_llx $lly_path} {$box_urx $lly_path}}] -net $net_shape -width $length -shape_use core_wire
#                  }
#               }
#            }
#      }
#  }
#}

proc gpinrb    { metal_pin metal_layer list_pin rbname} {
   foreach_in_col EACH_PORT $list_pin {
      set net_shape [get_attribute [get_nets -of [get_pins $EACH_PORT] -phy] name]
      foreach_in_collection metal_pin_shape [get_shapes -of_objects [get_pins -physical_context  $EACH_PORT] -filter layer.name==$metal_pin ] {
         #set net_shape [get_attribute $metal_pin_shape owner.name]
         set poly_pin [split_polygons -objects $metal_pin_shape -output poly_rect]
            foreach_in_collection shape_i $poly_pin {
               set box     [get_attribute -quiet  $shape_i bbox]
               create_routing_blockage -boundary [subst {$box}] \
                        -layers $metal_layer \
                        -name_prefix RB_${rbname}
            }
      }
  }
}

proc gpinshape { metal_pin metal_layer list_pin } {
   foreach_in_col EACH_PORT $list_pin {
      set net_shape [get_attribute [get_nets -of [get_pins $EACH_PORT] -phy] name]
      foreach_in_collection metal_pin_shape [get_shapes -of_objects [get_pins -physical_context  $EACH_PORT] -filter layer.name==$metal_pin ] {
         #set net_shape [get_attribute $metal_pin_shape owner.name]
         set poly_pin [split_polygons -objects $metal_pin_shape -output poly_rect]
            foreach_in_collection shape_i $poly_pin {
               set box     [get_attribute -quiet  $shape_i bbox]
               if { $box   != ""} {
                  set box_llx [lindex [lindex $box 0] 0]
                  set box_lly [lindex [lindex $box 0] 1]
                  set box_urx [lindex [lindex $box 1] 0]
                  set box_ury [lindex [lindex $box 1] 1]
                  set width  [expr abs ( $box_urx - $box_llx)]
                  set length [expr abs ( $box_lly - $box_ury)]
                  if { $width  < $length} {
                    set llx_path [ expr $box_llx + ( $width * 0.5 ) ]
                    create_shape -shape_type path -layer $metal_layer -path  [subst {{$llx_path $box_lly} {$llx_path $box_ury}}] -net $net_shape  -width $width -shape_use stripe
                  } else {
                    set lly_path [ expr $box_lly + ( $length * 0.5 ) ]
                    create_shape -shape_type path -layer $metal_layer -path  [subst {{$box_llx $lly_path} {$box_urx $lly_path}}] -net $net_shape -width $length -shape_use stripe
                  }
               }
            }
      }
  }
}

proc gpinshape_io_m8 { list_pin } {
   foreach_in_col EACH_PORT $list_pin {
      set orient     [get_attribute [get_cells -of [get_pins $EACH_PORT]] orientation]
      set net_shape [get_attribute [get_nets -of [get_pins $EACH_PORT] -phy] name]
      foreach_in_collection metal_pin_shape [get_shapes -of_objects [get_pins -physical_context  $EACH_PORT] -filter layer.name==M8 ] {
         #set net_shape [get_attribute $metal_pin_shape owner.name]
         set poly_pin [split_polygons -objects $metal_pin_shape -output poly_rect]
            foreach_in_collection shape_i $poly_pin {
               set box     [get_attribute -quiet  $shape_i bbox]
               if { $box   != ""} {
                  set box_llx [lindex [lindex $box 0] 0]
                  set box_lly [lindex [lindex $box 0] 1]
                  set box_urx [lindex [lindex $box 1] 0]
                  set box_ury [lindex [lindex $box 1] 1]
                  set width  [expr abs ( $box_urx - $box_llx)]
                  set length [expr abs ( $box_lly - $box_ury)]
                  # if IO is horizontal => M8 is vertical
                  # if IO is vertical   => M8 is horizontal
                  # horizontal IO
                  if {$orient == "R270" || $orient == "MXR90" || $orient == "R90" || $orient == "MYR90"} {
                    set llx_path [ expr $box_llx + ( $width * 0.5 ) ]
                        # create M8 vertical
                    set _ [create_shape -shape_type path -layer M8 -path  [subst {{$llx_path $box_lly} {$llx_path $box_ury}}] -net $net_shape  -width $width -shape_use stripe]
                    set_attr $_ tag io
                    # vertical IO
                    } else {
                      set lly_path [ expr $box_lly + ( $length * 0.5 ) ]
                          # create M8 horizontal
                    set _ [create_shape -shape_type path -layer M8 -path  [subst {{$box_llx $lly_path} {$box_urx $lly_path}}] -net $net_shape -width $length -shape_use stripe]
                    set_attr $_ tag io
                    }
               }
            }
      }
  }
}

proc gpinshape2 {} {
foreach_in_col pin [get_pins [get_selection]] {
   set poly_pin [split_polygons -objects [get_shapes -of [get_pins $pin]] -output poly_rect]
   set net_name [get_attribute [get_pins $pin] net_name]
   set layer    [get_attribute [get_pins $pin ] layer_name]
   foreach_in_collection shape_i $poly_pin {
     set box     [get_attribute -quiet  $shape_i  bbox]
     #set wwidth  [get_attribute -quiet  $shape_i  width]
     #set length  [get_attribute -quiet  $shape_i  length]
     if { $box   != ""} {
       set box_llx [lindex [lindex $box 0] 0]
       set box_lly [lindex [lindex $box 0] 1]
       set box_urx [lindex [lindex $box 1] 0]
       set box_ury [lindex [lindex $box 1] 1]
       set width  [expr abs ( $box_urx - $box_llx)]
       set length [expr abs ( $box_lly - $box_ury)]
       if { $width  < $length} {
         set is_vertical 1
         set llx_path [ expr $box_llx + ( $width * 0.5 ) ]
         create_shape -shape_type path -layer $layer -path  [subst {{$llx_path $box_lly} {$llx_path $box_ury}}] -net $net_name -shape_use core_wire -width $width
       } else {
         set is_vertical 0
         set lly_path [ expr $box_lly + ( $length * 0.5 ) ]
         create_shape -shape_type path -layer $layer -path  [subst {{$box_llx $lly_path} {$box_urx $lly_path}}] -net $net_name -shape_use core_wire -width $length
       }
     }
   }
}
}

proc gpinshape_VDD3 { list_pin } {
   global m5_sh
   foreach_in_col EACH_PORT $list_pin {
      set poly_pin_cut ""
      set net_shape [get_attribute [get_nets -of [get_pins $EACH_PORT] -phy] full_name]
      set sh_col [get_shapes -of_objects [get_pins -physical_context  $EACH_PORT] -filter layer.name==M5 ]
      #report_attributes $sh_col -app -nos
      foreach_in_collection metal_pin_shape $sh_col {
         set poly_pin [split_polygons -objects $metal_pin_shape -output poly_rect]
         set poly_box [get_attr $poly_pin bbox]
         set m8_sh    [get_shapes -intersect $poly_box -f owner.full_name==$net_shape&&layer.name==M8]
         #if {$m8_sh != ""} { puts "Found [sizeof_col $m8_sh] shapes M8"} else {puts "No M8 intersect!!"}
         foreach_in_col s   $m8_sh {
           set poly_v     [split_polygons [get_shapes $s ] -output poly_rect]
           set poly_v_cut [compute_polygons -objects1 $poly_pin -objects2 $poly_v -operation AND]
                   lappend poly_pin_cut $poly_v_cut
         }
            foreach  poly_i $poly_pin_cut {
                  set box [get_attr $poly_i bbox]
                  set box_llx [lindex  $box 0 0]
                  set box_lly [lindex  $box 0 1]
                  set box_urx [lindex  $box 1 0]
                  set box_ury [lindex  $box 1 1]
                  if {$box_lly!=$box_ury} {
                    set width  [expr abs ( $box_urx - $box_llx)]
                    set length [expr abs ( $box_lly - $box_ury)]
                  } else { continue }
                  if {$length > 2} {
                    set via_edge_space [expr ($length - 2)*(-0.5)]
                    set poly_i [resize_polygons -objects $poly_i -size [subst {0 $via_edge_space  0 $via_edge_space}]]
                    set box [get_attr $poly_i bbox]
                    set box_llx [lindex  $box 0 0]
                    set box_lly [lindex  $box 0 1]
                    set box_urx [lindex  $box 1 0]
                    set box_ury [lindex  $box 1 1]
                    set width  [expr abs ( $box_urx - $box_llx)]
                    set length [expr abs ( $box_lly - $box_ury)]
                  }
                  set llx_path [ expr $box_llx + ( $width * 0.5 ) ]
                  lappend m5_sh [create_shape -shape_type path -layer M5 -path  [subst {{$llx_path $box_lly} {$llx_path $box_ury}}] -net $net_shape -shape_use core_wire -width $width]
            }
      }
  }
}

proc gpinshape_RAM { metal_pin metal_layer list_pin } {
   foreach_in_col EACH_PORT $list_pin {
      set net_shape [get_attribute [get_nets -of [get_pins $EACH_PORT] -phy] name]
      foreach_in_collection metal_pin_shape [get_shapes -of_objects [get_pins -physical_context  $EACH_PORT] -filter layer.name==$metal_pin ] {
         #set net_shape [get_attribute $metal_pin_shape owner.name]
         set poly_pin [split_polygons -objects $metal_pin_shape -output poly_rect]
            foreach_in_collection shape_i $poly_pin {
               set box     [get_attribute -quiet  $shape_i bbox]
               if { $box   != ""} {
                  set box_llx [lindex [lindex $box 0] 0]
                  set box_lly [lindex [lindex $box 0] 1]
                  set box_urx [lindex [lindex $box 1] 0]
                  set box_ury [lindex [lindex $box 1] 1]
                  set width  [expr abs ( $box_urx - $box_llx)]
                  set length [expr abs ( $box_lly - $box_ury)]
                  if { $width  < $length} {
                    set llx_path [ expr $box_llx + ( $width * 0.5 ) ]
                    set _ [create_shape -shape_type path -layer $metal_layer -path  [subst {{$llx_path $box_lly} {$llx_path $box_ury}}] -net $net_shape  -width $width -shape_use stripe]
                    set_attr $_ tag R_check
                  } else {
                    set lly_path [ expr $box_lly + ( $length * 0.5 ) ]
                    set _ [create_shape -shape_type path -layer $metal_layer -path  [subst {{$box_llx $lly_path} {$box_urx $lly_path}}] -net $net_shape -width $length -shape_use stripe]
                    set_attr $_ tag R_check
                  }
               }
            }
      }
  }
}

proc gpinshape_FLASH { metal_pin metal_layer list_pin } {
   foreach_in_col EACH_PORT $list_pin {
      set net_shape [get_attribute [get_nets -of [get_pins $EACH_PORT] -phy] name]
      foreach_in_collection metal_pin_shape [get_shapes -of_objects [get_pins -physical_context  $EACH_PORT] -filter layer.name==$metal_pin ] {
         #set net_shape [get_attribute $metal_pin_shape owner.name]
         set poly_pin [split_polygons -objects $metal_pin_shape -output poly_rect]
            foreach_in_collection shape_i $poly_pin {
               set box     [get_attribute -quiet  $shape_i bbox]
               if { $box   != ""} {
                  set box_llx [lindex [lindex $box 0] 0]
                  set box_lly [lindex [lindex $box 0] 1]
                  set box_urx [lindex [lindex $box 1] 0]
                  set box_ury [lindex [lindex $box 1] 1]
                  set width  [expr abs ( $box_urx - $box_llx)]
                  set length [expr abs ( $box_lly - $box_ury)]
                  if { $width  < $length} {
                    set llx_path [ expr $box_llx + ( $width * 0.5 ) ]
                    set _ [create_shape -shape_type path -layer $metal_layer -path  [subst {{$llx_path $box_lly} {$llx_path $box_ury}}] -net $net_shape  -width $width -shape_use stripe]
                    set_attr $_ tag F_check
                  } else {
                    set lly_path [ expr $box_lly + ( $length * 0.5 ) ]
                    set _ [create_shape -shape_type path -layer $metal_layer -path  [subst {{$box_llx $lly_path} {$box_urx $lly_path}}] -net $net_shape -width $length -shape_use stripe]
                    set_attr $_ tag F_check
                  }
               }
            }
      }
  }
}
# To sort of shape collection which has proper name
proc gsel { shape_owner} {
  change_selection [get_shapes [get_selection ] -f "owner.name==$shape_owner"]
}

proc gpin { pin_name } {
  change_selection [get_pins -hier -phys -f  "full_name==$pin_name||full_name=~*$pin_name*"]
}

proc gcel { cell_name } {
  change_selection [get_flat_cells -all -f  "ref_name==$cell_name||full_name=~*$cell_name*"]
}
#To change layer of shape

proc glay { layer } {\
    foreach_in_col object [get_selection] {
        set_snap_setting -enabled {false}
        gui_change_layer -object [get_shapes $object] -layer $layer
    }
}

#================================================================================
#=======================HOTKEY INCREASE VIAS======================================
#================================================================================
#---- INPUT: Click object want to increase and press CTRL +RIGHT
#---- OUTPUT: VIAS of object incerase
#=====================\\\\\\\\\\\//////////////==================================
#================================================================================
gui_set_hotkey -hot_key "Ctrl + right" -replace -tcl_cmd {
  foreach_in_col via [get_vias [get_selection]] {
    gui_change_via_size -via $via -rows [get_attribute [get_selection  ] number_of_rows] -columns [expr [get_attribute [get_selection  ] number_of_columns]+1]
  }
}

#================================================================================
#=======================HOTKEY REDUCE VIAS======================================
#================================================================================
#---- INPUT: Click object want to reduce and press CTRL +LEFT
#---- OUTPUT: VIAS of object incerase
#=====================\\\\\\\\\\\//////////////==================================
#================================================================================
gui_set_hotkey -hot_key "Ctrl + left" -replace -tcl_cmd {
  foreach_in_col via [get_vias [get_selection]] {
    gui_change_via_size -via $via -rows [get_attribute [get_selection  ] number_of_rows] -columns [expr [get_attribute [get_selection  ] number_of_columns]-1]
  }
}
#================================================================================
#=======================HOTKEY REDUCE VIAS======================================
#================================================================================
#---- INPUT: Click object want to reduce and press CTRL +DOWN
#---- OUTPUT: VIAS of object incerase
#=====================\\\\\\\\\\\//////////////==================================
#================================================================================
gui_set_hotkey -hot_key "Ctrl + down" -replace -tcl_cmd {
  foreach_in_col via [get_vias [get_selection]] {
    gui_change_via_size -via $via -rows [expr [get_attribute [get_selection  ] number_of_rows]-1] -columns [get_attribute [get_selection  ] number_of_columns]
  }
}
#================================================================================
#=======================HOTKEY REDUCE VIAS======================================
#================================================================================
#---- INPUT: Click object want to reduce and press CTRL +UP
#---- OUTPUT: ROW VIAS of object incerase
#=====================\\\\\\\\\\\//////////////==================================
#================================================================================
gui_set_hotkey -hot_key "Ctrl + up" -replace -tcl_cmd {
  foreach_in_col via [get_vias [get_selection]] {
    gui_change_via_size -via $via -rows [expr [get_attribute [get_selection  ] number_of_rows]+1] -columns [get_attribute [get_selection  ] number_of_columns]
  }
}





###### check LVS ######
proc gLVS {chk} { \
 check_lvs -checks $chk -max_errors 0 -open_reporting detailed
} \

###### copy object selection ######
proc gcopyx {x} { \
set_snap_setting -enabled {false}
change_selection [copy_objects [get_selection ]  -delta [subst {$x 0}] ]
}


proc gcopyy {y} { \
set_snap_setting -enabled {false}
change_selection [copy_objects [get_selection ]  -delta [subst {0 $y}] ]
}

proc gcopy { x y} { \
set_snap_setting -enabled {false}
change_selection [copy_objects [get_selection ]  -delta [subst {$x $y}] ]
}
#================================================================================
#=======================COPPY OVERLAP LAYER======================================
#================================================================================
#---- INPUT: Click object want to coppy and write name proceture + layer
#---- OUTPUT: New layer will creace and place  is overlap layer coppiedid
#=====================\\\\\\\\\\\//////////////==================================
#================================================================================

proc gcoppy_overlaps { layer } {\
set_snap_setting -enabled {false}
change_selection [copy_object [get_selection ] -delta [subst {0 0}] ]
foreach_in_collection shape [get_shapes [get_selection]] {\
        change_selection [gui_change_layer -object [get_shapes $shape] -layer $layer]-add
        }
}
#--------------------------------------END--------------------------------------


#================================================================================
#---- INPUT: Click object want to coppy and write name proceture + layer
#---- OUTPUT: New layer will creace and place  is overlap layer coppiedid
#=====================\\\\\\\\\\\//////////////==================================
#================================================================================

proc gcoppy_layer   { layer } {\
        set_snap_setting -enabled {false}
   foreach_in_col obj [get_selection] {
        change_selection [copy_object $obj -delta [subst {0 0}] ]
        gui_change_layer -object $obj -layer $layer
   }
}
#--------------------------------------END--------------------------------------



#================================================================================
#=======================CHANGE SHAPE USE FOR SHAPE===============================
#================================================================================
#---- INPUT: Click object want to change shape use and write name procedure + layer want to change shape_use
#---- OUTPUT: Shape have been changed shape use
#=====================\\\\\\\\\\\//////////////==================================
#================================================================================

proc gchange_shape_use_of_shape {shape_use} {\
        set_snap_setting -enabled {false}
        set_attribute -objects [get_shapes [get_selection]] -name shape_use -value $shape_use
}

#--------------------------------------END--------------------------------------


#================================================================================
#=======================CHANGE SHAPE USE FOR VIAS===============================
#================================================================================
#---- INPUT: Click object want to change shape use and write name procedure + layer want to change shape_use
#---- OUTPUT: Shape have been changed shape use
#=====================\\\\\\\\\\\//////////////==================================
#================================================================================

proc gchange_shape_use_of_vias {shape_use} {\
  set_snap_setting -enabled {false}
  set_attribute -objects [get_vias [get_selection]] -name shape_use -value $shape_use
}

#--------------------------------------END--------------------------------------


#================================================================================
#=============================COPPY BASE ON LENGTH===============================
#================================================================================
#---- INPUT: XY: Direction want copy:
#                                                                       Set x if you want to coppy horizontal form BOTTOM to TOP
#                 Set -x if you want to coppy horizontal form TOP to BOTTOM
#                 Set y if you want to coppy vertical form BOTTOM to TOP
#                                                                       Set -y if you want to coppy vertical form TOP to BOTTOM
#                                               Delta: Space form current object to new object
#                                               Width: Width of object
#                 Length: Length want to coppy
#
#---- OUTPUT:
#=====================\\\\\\\\\\\//////////////==================================
#================================================================================

proc gcoppy_base_on_length {XY DELTA LENGTH } {\
        set WIDTH [get_attribute [get_selection ] width]
  set_snap_setting -enabled {false}
        if {$XY =="" && $DELTA=="" && $LENGTH ==""} {
                echo "................TT"
        } elseif {$XY =="x"} {
                        set TIME [format %.0f [expr $LENGTH/$DELTA]]
                        set PITCH [expr $DELTA - $WIDTH]
                        copy_objects -x_times $TIME -x_pitch  $PITCH -delta  [subst {$DELTA 0}]
        ## Case -x
        }       elseif {$XY =="-x"} {
      set TIME [format %.0f [expr $LENGTH/$DELTA]]
      set PITCH [expr -$DELTA - $WIDTH]
      copy_objects -x_times $TIME -x_pitch  $PITCH -delta  [subst {-$DELTA 0}]
        ## Case y
        }       elseif {$XY =="y"} {
      set TIME [format %.0f [expr $LENGTH/$DELTA]]
      set PITCH [expr $DELTA - $WIDTH]
      copy_objects -y_times $TIME -y_pitch  $PITCH -delta  [subst {0 $DELTA}]
  ## Case -y
        }  elseif {$XY =="-y"} {
      set TIME [format %.0f [expr $LENGTH/$DELTA]]
      set PITCH [expr -$DELTA - $WIDTH]
      copy_objects -y_times $TIME -y_pitch  $PITCH -delta  [subst {0 -$DELTA}]
        } else {
        echo "ERROR! Please setting the valid XY value"
                        }
}
#--------------------------------------END--------------------------------------





##########move object selection ###########
proc gmove {x y} { \
set_snap_setting -enabled {false}
move_objects [get_selection ]  -delta [subst {$x $y}]
}


proc gmovex {x} { \
set_snap_setting -enabled {false}
move_objects [get_selection ]  -delta [subst {$x 0}]
}


proc gmovey {y} { \
set_snap_setting -enabled {false}
move_objects [get_selection ]  -delta [subst {0 $y}]
}

########remove cell########################

proc cell_copy {x y } {
set num 0
if {[sizeof_collection [get_cells [get_selection]]] > 0} {
   foreach_in_collection cell [get_cells [get_selection]] {
      while {[sizeof_collection [get_cells -quiet  [get_attribute [get_cells -quiet  $cell] full_name]_copy$num]] != 0 } {
        incr num
        }
      move_objects [create_cell [get_attribute [get_cells $cell] full_name]_copy$num  */[get_attribute [get_cells $cell ] ref_name]] -to [get_attribute [get_cells $cell ] bbox_ll]
      move_objects [get_cells [get_attribute [get_cells $cell] full_name]_copy$num] -delta [subst {$x $y}]
      puts [get_attribute [get_cells $cell] full_name]_copy$num
   }
}
}

proc grm_non_sel { } {
remove_cells [get_cells [get_selection ] -f full_name=~NON*]
}

proc grm_non_all { } {
remove_cells [get_cells  -f full_name=~NON*]
}

########### change net name for shape AND VIA selection###############

proc gchange_net_name_via {to_net} { \
   foreach_in_collection  via [get_vias [get_selection]] {
   set fr_net [get_attribute [get_vias $via ] owner]
   remove_from_net $fr_net [get_vias $via ]
   add_to_net $to_net [get_vias $via]
   }
}

proc gchange_net_name_shape {to_net} { \
   foreach_in_collection  shape [get_shapes [get_selection]] {
   set fr_net [get_attribute [get_shapes $shape ] owner]
   remove_from_net $fr_net [get_shapes $shape ]
   add_to_net $to_net [get_shapes $shape]
   }
}

###########gcreate routing blockage in selection ######

proc gcreate_placement_blockage { space } {

  foreach_in_collection  sel [get_selection] {
     set bbox [get_attribute $sel bbox ]
     set llx [lindex [lindex $bbox 0] 0]
     set lly [lindex [lindex $bbox 0] 1]
     set urx [lindex [lindex $bbox 1] 0]
     set ury [lindex [lindex $bbox 1] 1]
     create_placement_blockage -boundary [subst {{[expr $llx -$space] [expr $lly -$space]} {[expr $urx + $space] [expr $ury +$space]}}]
  }
}


###### change with for shape selection#################
proc gchange_width {to_width} { set_attribute [get_selection ] width "$to_width" }

###### merge 2 or more net shape ##############
proc gmerge_object { } {merge_objects [get_selection ]}

##########create via from layer to layer for shape selection ########################
#### selection shape before apply command#######################

proc gv {to_layer } {\
   set net_name  [lsort -unique [get_attribute [get_selection] owner.name]]
   #set net_name [lsort -unique [get_attribute [get_nets  -of [get_shapes [get_selection]]]] full_name]
   set layer_net [lsort -unique [get_attribute [get_selection] layer_name]]
   foreach_in_collection shape [get_shapes [get_selection]] {
        set via_master [list VIA12_LONG_H VIA23_LONG_H VIA34_LONG_H VIA45_LONG_H]
        set_pg_via_master_rule \
            via_rule_1 -contact_code VIA89_1cut_H_3S \
            -via_array_dimension {4 3}
#       create_pg_vias -allow_parallel_objects  -net $net_name  -from_layers $layer_net -to_layers $to_layer -within_bbox [ get_attribute [get_shapes $shape] bbox]  -via_ma
        create_pg_vias -allow_parallel_objects  -net $net_name  -from_layers $layer_net -to_layers $to_layer -within_bbox [ get_attribute [get_shapes $shape] bbox]
   }
}

proc gvx {to_layer } {\
   set net_name  [lsort -unique [get_attribute [get_selection] owner.name]]
   #set net_name [lsort -unique [get_attribute [get_nets  -of [get_shapes [get_selection]]]] full_name]
   set layer_net [lsort -unique [get_attribute [get_selection] layer_name]]
   foreach_in_collection shape [get_shapes [get_selection]] {
        set via_master [list VIA56_PGx VIA67_PGx VIA78_PGx]
        create_pg_vias -allow_parallel_objects  -net $net_name  -from_layers $layer_net -to_layers $to_layer -within_bbox [ get_attribute [get_shapes $shape] bbox] -via_masters [subst {$via_master}]
   }
}

proc gv_via8_4x4 { } {\
   #set net_name [lsort -unique [get_attribute [get_nets  -of [get_shapes [get_selection]]]] full_name]
   foreach_in_collection shape [get_shapes [get_selection]] {
        set_pg_via_master_rule via89_4x4 -contact_code VIA89_1cut -cut_spacing {0.66 0.66}
        set net_name  [get_attribute $shape owner.name]
        create_pg_vias -allow_parallel_objects  -net $net_name  -from_layers M8 -to_layers M9 -within_bbox [ get_attribute [get_shapes $shape] bbox] -via_masters via89_4x4
   }
}
proc gv_via7_4x4 { } {\
   #set net_name [lsort -unique [get_attribute [get_nets  -of [get_shapes [get_selection]]]] full_name]
   foreach_in_collection shape [get_shapes [get_selection]] {
        set_pg_via_master_rule via78_4x4 -contact_code VIA78_1cut -cut_spacing {0.66 0.66}
        set net_name  [get_attribute $shape owner.name]
        create_pg_vias -allow_parallel_objects  -net $net_name  -from_layers M7 -to_layers M8 -within_bbox [ get_attribute [get_shapes $shape] bbox] -via_masters via78_4x4
   }
}

proc gcreate_vias_not_parallel {fr_layer to_layer net} {\
   foreach_in_collection shape [get_shapes [get_selection]] {
  create_pg_vias -net $net  -from_layers $fr_layer -to_layers $to_layer -within_bbox [ get_attribute [get_shapes $shape] bbox]
   }
}


proc gcreate_via_89_core { net } {\
        set via_master [list VIA12_LONG_H VIA23_LONG_H VIA34_LONG_H VIA45_LONG_H]
        set_pg_via_master_rule \
            via_rule_1 -contact_code VIA89_1cut_H_3S \
            -via_array_dimension {4 3}
        create_pg_vias -allow_parallel_objects  -net $net  -from_layers M8 -to_layers M9 -within_bbox [ get_attribute [get_core_area] bbox]  -via_masters [subst {$via_master via_rule_1}] -mark_as user_route
}

proc gcreate_vias_sram_m8 { net } {
     set_snap_setting -enabled false
     set_app_options -name plan.pgroute.via_site_threshold -value 0.4
     set bbox [get_attribute [get_selection] bbox]
     set_pg_via_master_rule pg_via5_VDD -via_array_dimension {1 2} -contact_code VIA56_HH_PG -track_alignment top_half_track_only -offset {0 0.4}
     set_pg_via_master_rule pg_via5_VSS -via_array_dimension {1 2} -contact_code VIA56_HH_PG -track_alignment top_half_track_only -offset {0 -0.4}
     set_pg_via_master_rule pg_via6_VDD -via_array_dimension {1 2} -contact_code VIA67_HH_PG -track_alignment bottom_half_track_only -offset {0 0.4}
     set_pg_via_master_rule pg_via6_VSS -via_array_dimension {1 2} -contact_code VIA67_HH_PG -track_alignment bottom_half_track_only -offset {0 -0.4}
     set_pg_via_master_rule pg_via7     -via_array_dimension {1 2} -contact_code VIA78_PG


     create_pg_vias -net $net -from_layers M5 -to_layers M8 -within_bbox $bbox -via_masters [subst {pg_via5_$net pg_via6_$net pg_via7 }] -mark_as macro_pin_connect

}
#######write route  all signal net################
proc gwrite_route_signal {out_put} {\
        change_selection [get_shapes -filter net_type==signal]
        change_selection [get_vias -filter net_type==signal] -add
        write_routes -objects [get_selection ] -output $out_put
}


############# create shape from pin to core areas ########
############  length of shape == space            ######
############  layer of shape == M4                #################

proc gshape {space vertical layer width} {
        set pins [get_pins [get_selection]]
        set layer $layer
        set width $width
        set pitch 0.32
        foreach_in_collection pin $pins {
                set bbox ""
                set bbox [get_attribute [get_pins $pin ] bbox]
                if { $bbox != ""} {
                        set llx [lindex [lindex $bbox 0] 0]
                        set lly [lindex [lindex $bbox 0] 1]
                        set urx [lindex [lindex $bbox 1] 0]
                        set ury [lindex [lindex $bbox 1] 1]
                        set centerx [expr $llx/2 + $urx/2]
                        set centery [expr $lly/2 + $ury/2]
                        set y_new [expr $centery -$space]
                        set x_new [expr $centerx +$space]

                        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -start CreateRouteTool
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalLayer} -value $layer
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalPitch} -value $pitch
                        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst { $centerx $centery }] -scale 0.0001

                        gui_set_mouse_tool_option -tool CreateRouteTool -option {VerticalLayer} -value $layer
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {VerticalWidth} -value $width
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {VerticalPitch} -value $pitch
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalLayer} -value $layer
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalWidth} -value $width
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalPitch} -value $pitch
                        if {$vertical == 1} {
                                  gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst { $centerx $y_new }] -scale 0.0002
                        } else {
                                gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst { $x_new $centery }] -scale 0.0002

                                gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalLayer} -value $layer
                                gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalWidth} -value $width
                                gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalPitch} -value $pitch
                        }
                        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -apply
                        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -reset
                } else {
                        puts "warning : pin $pin do not exits in design ->>>>>>>>>>>>>"
                }
        }
}

### create M4 from shape selection with length M4 = space ##########################
proc gshape_fr_shape {space vertical left_bottom} {
        set layer M4
        set width 0.22
        set pitch 0.32
        set shapes [get_shapes [get_selection]]
        foreach_in_collection shape $shapes {
                set bbox ""
                set bbox [get_attribute [get_shapes $shape ] bbox]
                set full_name [get_attribute [get_shapes $shape ] full_name]
                if { $bbox != ""} {
                        set llx [lindex [lindex $bbox 0] 0]
                        set lly [lindex [lindex $bbox 0] 1]
                        set urx [lindex [lindex $bbox 1] 0]
                        set ury [lindex [lindex $bbox 1] 1]
                        set centerx [expr $llx/2 + $urx/2]
                        set centery [expr $lly/2 + $ury/2]
                        set y_new [expr $centery -$space]
                        set x_new [expr $centerx +$space]
                        if {$left_bottom ==1 && $vertical == 1 } {
                                set x_start [expr $centerx + 0 ]
                                set y_start [expr $lly + 0.5 ]
                                set x_end [expr $x_start + 0]
                                set y_end [expr $y_start - $space]
                                puts "xxxxxxxxxxonexxxxxxxxxx"
                        }
                        if {$left_bottom ==1 && $vertical == 0 } {
                                set x_start [expr $llx + 0.5 ]
                                set y_start [expr $centery + 0.0 ]
                                set x_end [expr $x_start - $space]
                                set y_end [expr $y_start - 0]
                                puts "xxxxxxxxxxtwoxxxxxxxxxx"
                        }
                         if {$left_bottom ==0 && $vertical == 1 } {
                                set x_start [expr $centerx + 0 ]
                                set y_start [expr $ury - 0.5 ]
                                set x_end [expr $x_start + 0]
                                set y_end [expr $y_start + $space]
                                puts "xxxxxxxxxxthreexxxxxxxxxx"
                        }
                         if {$left_bottom ==0 && $vertical == 0 } {
                                set x_start [expr $urx - 0.5 ]
                                set y_start [expr $centery + 0.0 ]
                                set x_end [expr $x_start + $space]
                                set y_end [expr $y_start - 0]
                                puts "xxxxxxxxxxfourxxxxxxxxxx"
                        }


                        change_selection [get_shape $full_name]
                        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -start CreateRouteTool
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalLayer} -value $layer
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalPitch} -value $pitch
                        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst { $x_start $y_start }] -scale 0.0001
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {VerticalLayer} -value $layer
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {VerticalWidth} -value $width
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {VerticalPitch} -value $pitch
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalLayer} -value $layer
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalWidth} -value $width
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalPitch} -value $pitch

                                gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst { $x_end $y_end }] -scale 0.0002
                                gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalLayer} -value $layer
                                gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalWidth} -value $width
                                gui_set_mouse_tool_option -tool CreateRouteTool -option {HorizontalPitch} -value $pitch
                        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -apply
                        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -reset
                        puts "finished create routing "
                } else {
                        puts "warning : shape $shape do not exits in design ->>>>>>>>>>>>>"
                }
        }
}

proc greport_wire_length { list_net } {
 foreach net $list_net {
  set net_length [get_attribute [get_nets $net] route_length]
  set max_shape  [llength $net_length]
  set num  0
  set total_length  0
  foreach i $net_length {
   #puts $num
   set shape_lay    [lindex $i  0]
   set shape_length [lindex $i  1]
   set total_length [expr $total_length + $shape_length]
   #puts $total_length
  }
  puts "----"
  puts "Net: $net - Length: $total_length um"
 }
}

proc proc_start_time {} {
  set ::start_time_step [clock seconds]
  echo "StartTime: [clock format ${::start_time_step} -format {%Y-%m-%d %H:%M:%S} -gmt false]"
}

proc proc_end_time {} {
  set ::end_time_step [clock seconds]
  echo "EndTime: [clock format ${::end_time_step} -format {%Y-%m-%d %H:%M:%S} -gmt false]"
  echo "ElapseTime: [format %02d [expr ( ${::end_time_step} - ${::start_time_step} ) / 86400]]d[clock format \
    [expr ( ${::end_time_step} - ${::start_time_step} )] -format %Hh%Mm%Ss -gmt true]"
}

proc pin_center {list_cell} {
  #set lst_cell "
  #systop/dcdc_top/dcdc
  #"
  #cell -> pin name/net_name -> layer -> bbox
  set num 1
  foreach cell $list_cell {
    puts "$num. CELL: $cell"
    foreach_in_col pin [get_pins -of [get_cells $cell ] -f "pg_type==primary&&(port_type==ground||port_type==power)"] {
      set pname  [get_attribute $pin  name]
      set nname  [get_attribute [get_nets -phys -of  $pin] name]

      foreach_in_col shape [get_shapes -of [get_pins $pin]] {
        set poly_pin [split_polygons -objects [get_shapes -of [get_pins $pin]] -output poly_rect]
        set lay   [get_attribute $shape layer_name]
        #set coor  [get_attribute $shape bbox]
        if {[sizeof_collection $poly_pin] > 1} {
           set coor [lindex [get_attribute $poly_pin bbox] 0]
        } else {set coor  [get_attribute $poly_pin bbox] }
        #set coor  [get_attribute $shape bbox]
        set lay_num       [format {%s} [string map {{M} {WM}} $lay]]
        if {$lay_num=="AP"} {set lay_num "WMA"}
        set llx   [lindex [lindex $coor 0] 0]
        set lly   [lindex [lindex $coor 0] 1]
        set urx   [lindex [lindex $coor 1] 0]
        set ury   [lindex [lindex $coor 1] 1]
        set x_center      [expr ($llx + $urx)/2]
        set y_center      [expr ($lly + $ury)/2]
        puts "$pname $nname $x_center $y_center $lay_num"
      }
    }
    incr num
  }
}


proc gpattern { {space 0.8} {width 4} {net "VSS"} {layer "M9"} {offset 0} {shape_use "core_wire" }} {
puts "\[INF\] Generate pattern using below information: icc_shell> gpattern space width net layer offset shape_use"
set width_half  [expr ($width/2)]
set HM_box      [get_attribute [get_selection] bbox]
set HM_bound    [get_attribute [get_selection] boundary]
# get para
if { $HM_box   != ""} {
  set box_llx [lindex [lindex $HM_box 0] 0]
  set box_lly [lindex [lindex $HM_box 0] 1]
  set box_urx [lindex [lindex $HM_box 1] 0]
  set box_ury [lindex [lindex $HM_box 1] 1]
  set HM_w    [expr abs ($box_urx - $box_llx)]
  set HM_h    [expr abs ($box_ury - $box_lly)]
}

# create shape from left to right
#set offset         0
set shape_w_s      [expr $width + $space]
#set shape_w_s      [expr $space]
set box_llx        [expr $box_llx + $offset ]

  while {$HM_w  >= $width} {
    #puts "shape llx: [expr $box_llx + $width_half]"
    set box_llx_mod    [expr $box_llx + $width_half]
    create_shape -shape_type path -layer $layer -path  [subst {{$box_llx_mod $box_lly} {$box_llx_mod $box_ury}}] -net $net -shape_use $shape_use -width $width
    set box_llx [expr $box_llx + $shape_w_s]
    set HM_w    [expr $HM_w - $shape_w_s]
    #puts "check:  $HM_w"
  }
  puts "\[INF\] Finished."

}

proc gpattern2 { {space 0.8} {width 4} {net "VSS"} {layer "M9"} {offset 0} {shape_use "core_wire" }} {
puts "\[INF\] Generate pattern using below information: icc_shell> gpattern space width net layer offset shape_use"
set width_half  [expr ($width/2)]
set HM_box      [get_attribute [get_selection] bbox]
set HM_bound    [get_attribute [get_selection] boundary]
# get para
if { $HM_box   != ""} {
  set box_llx [lindex [lindex $HM_box 0] 0]
  set box_lly [lindex [lindex $HM_box 0] 1]
  set box_urx [lindex [lindex $HM_box 1] 0]
  set box_ury [lindex [lindex $HM_box 1] 1]
  set HM_w    [expr abs ($box_urx - $box_llx)]
  set HM_h    [expr abs ($box_ury - $box_lly)]
}

# create shape from bottom to top
#set offset         0
set shape_w_s      [expr $width + $space]
#set shape_w_s      [expr $space]
set box_lly        [expr $box_lly + $offset ]

  while {$HM_h  >= $width} {
    #puts "shape llx: [expr $box_llx + $width_half]"
    set box_lly_mod    [expr $box_lly + $width_half]
    create_shape -shape_type path -layer $layer -path  [subst {{$box_llx $box_lly_mod} {$box_urx $box_lly_mod}}] -net $net -shape_use $shape_use -width $width
    set box_lly [expr $box_lly + $shape_w_s]
    set HM_h    [expr $HM_h - $shape_w_s]
    #puts "check:  $HM_w"
  }
  puts "\[INF\] Finished."

}


#proc gshape_rotate {} {
#  foreach_in_col shape [get_shapes [get_selection]] {
#    set bbox [get_attribute $shape bbox]
#    set lay  [get_attribute $shape layer.name]
#    set typ  [get_attribute $shape shape_use]
#    set net  [get_attribute $shape owner.name]
#    set width   [get_attribute $shape length]
#    set length  [get_attribute $shape width]
#    set llx [lindex [join $bbox] 0]
#    set lly [lindex [join $bbox] 1]
#    set urx [lindex [join $bbox] 2]
#    set ury [lindex [join $bbox] 3]
#    set new_llx [expr $llx + $width/2]
#    create_shape -shape_type path -shape_use $typ -width $width -path [subst {{$new_llx $lly} {$new_llx $ury}}] -net $net -layer $lay
#    remove_shapes $shape
#  }
#}
proc gshape_rotate {} {
  foreach_in_col shape [get_shapes [get_selection]] {
    move_objects $shape -rotate_by CW90 -group
  }
}


proc gcreate_routing_blockage { space rbname } {

  foreach_in_collection  sel [get_selection] {
     set bbox [get_attribute $sel bbox  ]
     set llay [get_attribute $sel layer ]
     set llx [lindex [lindex $bbox 0] 0]
     set lly [lindex [lindex $bbox 0] 1]
     set urx [lindex [lindex $bbox 1] 0]
     set ury [lindex [lindex $bbox 1] 1]

     create_routing_blockage -boundary [subst {{[expr $llx -$space] [expr $lly -$space]} {[expr $urx + $space] [expr $ury +$space]}}] \
              -layers $llay \
              -name_prefix RB_${rbname}
    }
}

proc gcreate_routing_blockage_for_m8_pg_mesh { space rbname } {

  foreach_in_collection  sel [get_selection] {
     set bbox [get_attribute $sel bbox  ]
     set net_typ [get_attribute $sel net_type ]
     set llay [get_attribute $sel layer ]
     set llx [lindex [lindex $bbox 0] 0]
     set lly [lindex [lindex $bbox 0] 1]
     set urx [lindex [lindex $bbox 1] 0]
     set ury [lindex [lindex $bbox 1] 1]

     create_routing_blockage -boundary [subst {{[expr $llx -$space] [expr $lly -$space]} {[expr $urx + $space] [expr $ury +$space]}}] \
              -layers $llay \
              -name_prefix RB_${rbname}
              --net_types ${net_typ}
    }
}


proc is_vertical { poly } {
  set box     [get_attribute -quiet  $poly  bbox]
  set wwidth  [get_attribute -quiet  $poly  width]
  if { $box   != ""} {
    set box_llx [lindex [lindex $box 0] 0]
    set box_lly [lindex [lindex $box 0] 1]
    set box_urx [lindex [lindex $box 1] 0]
    set box_ury [lindex [lindex $box 1] 1]
    if { abs ([ format %.4f [expr $box_llx - $box_urx] ]) == $wwidth} {
      return 1
    } elseif { abs ([ format %.4f [expr $box_lly - $box_ury] ]) == $wwidth } {
      return 0
    }
  }
}


proc greduce_shape_length { direction unit} {
  foreach_in_col i [get_shapes [get_selection]] {
    set net_name [get_attribute $i owner.name]
    set layer_name [get_attribute $i layer.name]
    set shape_use [get_attribute $i shape_use]
    #set length [get_attribute $i length]
    #set width [get_attribute $i width]
    set bbox [get_attribute $i bbox ]
    set llx [lindex [lindex $bbox 0] 0]
    set lly [lindex [lindex $bbox 0] 1]
    set urx [lindex [lindex $bbox 1] 0]
    set ury [lindex [lindex $bbox 1] 1]
    set width  [expr abs ( $urx - $llx)]
    set length [expr abs ( $lly - $ury)]

    if {[is_vertical $i]==0} {
      #define the center x of horizontal shape
      set lly [ expr $lly + ( $length * 0.5 ) ]
      if {$direction=="left"} {
        set new_llx [expr $llx + $unit]
        create_shape -shape_type path -layer $layer_name -path  [subst {{$new_llx $lly} {$urx $lly}}] -net $net_name -shape_use $shape_use -width $length
        remove_shapes [get_shapes $i]
      } elseif {$direction=="right"} {
        set new_urx [expr $urx - $unit]
        create_shape -shape_type path -layer $layer_name -path  [subst {{$llx $lly} {$new_urx $lly}}] -net $net_name -shape_use $shape_use -width $length
        remove_shapes [get_shapes $i]
      }
    } else {
      #define the center y of vertical shape
      set llx [ expr $llx + ( $width * 0.5 ) ]
      if {$direction=="top"} {
        set new_ury [expr $ury - $unit]
        create_shape -shape_type path -layer $layer_name -path  [subst {{$llx $lly} {$llx $new_ury}}] -net $net_name -shape_use $shape_use -width $width
        remove_shapes [get_shapes $i]
      } elseif {$direction=="bottom"} {
        set new_lly [expr $lly + $unit]
        create_shape -shape_type path -layer $layer_name -path  [subst {{$llx $new_lly} {$llx $ury}}] -net $net_name -shape_use $shape_use -width $width
        remove_shapes [get_shapes $i]
      }
    }
  }
}

#proc gmod_shape_length { direction unit} {
#  foreach_in_col i [get_shapes [get_selection]] {
#    set net_name [get_attribute $i owner.name]
#    set layer_name [get_attribute $i layer.name]
#    set shape_use [get_attribute $i shape_use]
#    #set length [get_attribute $i length]
#    #set width [get_attribute $i width]
#    set bbox [get_attribute $i bbox ]
#    set llx [lindex [lindex $bbox 0] 0]
#    set lly [lindex [lindex $bbox 0] 1]
#    set urx [lindex [lindex $bbox 1] 0]
#    set ury [lindex [lindex $bbox 1] 1]
#    set width  [expr abs ( $urx - $llx)]
#    set length [expr abs ( $lly - $ury)]
#
#    if {[is_vertical $i]==0} {
#      #define the center x of horizontal shape
#      set lly [ expr $lly + ( $length * 0.5 ) ]
#      if {$direction=="left"} {
#        set new_llx [expr $llx + $unit]
#        create_shape -shape_type path -layer $layer_name -path  [subst {{$new_llx $lly} {$urx $lly}}] -net $net_name -shape_use $shape_use -width $length
#        remove_shapes [get_shapes $i]
#      } elseif {$direction=="right"} {
#        set new_urx [expr $urx - $unit]
#        create_shape -shape_type path -layer $layer_name -path  [subst {{$llx $lly} {$new_urx $lly}}] -net $net_name -shape_use $shape_use -width $length
#        remove_shapes [get_shapes $i]
#      }
#    } else {
#      #define the center y of vertical shape
#      set llx [ expr $llx + ( $width * 0.5 ) ]
#      if {$direction=="top"} {
#        set new_ury [expr $ury - $unit]
#        create_shape -shape_type path -layer $layer_name -path  [subst {{$llx $lly} {$llx $new_ury}}] -net $net_name -shape_use $shape_use -width $width
#        remove_shapes [get_shapes $i]
#      } elseif {$direction=="bottom"} {
#        set new_lly [expr $lly + $unit]
#        create_shape -shape_type path -layer $layer_name -path  [subst {{$llx $new_lly} {$llx $ury}}] -net $net_name -shape_use $shape_use -width $width
#        remove_shapes [get_shapes $i]
#      }
#    }
#  }
#}
proc gresize_poly_by_length {_sh _l} {
  set _poly_obj [split_polygons -objects ${_sh} -output poly_rect]
  set _poly_rez [resize_polygons -objects ${_poly_obj} -size ${_l} ]
  set _poly_rez_box [get_attr $_poly_rez bbox]
  return $_poly_rez_box
}

proc gmod_shape_length_by_stretch { direction unit} {
  foreach_in_col i [get_shapes [get_selection]] {
    set coor [get_attribute $i points ]
    set x1 [lindex [lindex $coor 0] 0]
    set y1 [lindex [lindex $coor 0] 1]
    set x2 [lindex [lindex $coor 1] 0]
    set y2 [lindex [lindex $coor 1] 1]
    set sh_box_resize [gresize_poly_by_length $i $unit]

    if {$y1 == $y2} {
      # check if shape is horizontal
      # check if direction is left/right
      if {$direction == "left"} {
        set x1a [lindex $sh_box_resize 0 0]
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -start StretchTool
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst {$x1 $y1}] -scale 0.0555
        set_snap_setting -enabled {false}
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst {$x1a $y1}]  -scale 0.0555
        set_snap_setting -enabled {true}
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -reset

        #set_edit_setting -select_partial_object {true}
        #gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -start StretchTool
        #gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst {$x1 $y1}] -scale 0.1665
        #gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst {$x1a $y1}] -scale 0.1665
        #gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -apply
        #gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -reset

      } elseif {$direction == "right"} {
        #set x2a [expr $x2 + $unit]
        set x2a [lindex $sh_box_resize 1 0]
        set_edit_setting -select_partial_object {true}
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -start StretchTool
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst {$x2 $y2}] -scale 0.1665
        set_snap_setting -enabled {false}
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst {$x2a $y2}] -scale 0.1665
        set_snap_setting -enabled {true}
        #gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -apply
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -reset
      }
    } elseif {$x1 == $x2 } {
      # check if shape is vertical
      # check if direction is top/bottom
      if {$direction == "top"} {
        #set y2a [expr $y2 + $unit]
        set y2a [lindex $sh_box_resize 1 1]
        set_edit_setting -select_partial_object {true}
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -start StretchTool
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst {$x2 $y2}] -scale 0.1665
        set_snap_setting -enabled {false}
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst {$x2 $y2a}] -scale 0.1665
        set_snap_setting -enabled {true}
        #gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -apply
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -reset
      } elseif {$direction == "bottom"} {
        #set y1a [expr $y1 + $unit]
        set y1a [lindex $sh_box_resize 0 1]
        set_edit_setting -select_partial_object {true}
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -start StretchTool
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst {$x1 $y1}] -scale 0.1665
        set_snap_setting -enabled {false}
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point [subst {$x1 $y1a}] -scale 0.1665
        set_snap_setting -enabled {true}
        gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -reset
      }
    }
  }
}

# Reduce left side of shape 2 um
gui_set_hotkey -hot_key "Alt + A" -replace -tcl_cmd {
  gmod_shape_length_by_stretch left -2
}
# Reduce right side of shape 2 um
gui_set_hotkey -hot_key "Alt + D" -replace -tcl_cmd {
  gmod_shape_length_by_stretch right -2
}
# Reduce top side of shape 2 um
gui_set_hotkey -hot_key "Alt + W" -replace -tcl_cmd {
  gmod_shape_length_by_stretch top -2
}
# Reduce bottom side of shape 2 um
gui_set_hotkey -hot_key "Alt + S" -replace -tcl_cmd {
  gmod_shape_length_by_stretch bottom -2
}


# Increase left side of shape 2 um
gui_set_hotkey -hot_key "Ctrl + Alt + A" -replace -tcl_cmd {
  gmod_shape_length_by_stretch left 2
}
# Increase right side of shape 2 um
gui_set_hotkey -hot_key "Ctrl + Alt + D" -replace -tcl_cmd {
  gmod_shape_length_by_stretch right 2
}
# Increase top side of shape 2 um
gui_set_hotkey -hot_key "Ctrl + Alt + W" -replace -tcl_cmd {
  gmod_shape_length_by_stretch top 2
}
# Increase bottom side of shape 2 um
gui_set_hotkey -hot_key "Ctrl + Alt + S" -replace -tcl_cmd {
  gmod_shape_length_by_stretch bottom 2
}

### set tag name

proc gchange_tag_name {_tag} {\
        set_attribute -objects  [get_selection] -name tag -value ${_tag}
}

proc gring_VSS_M1_AD {list_ring_lay pin_lay list_net list_cell {tag "powerring"}} {
  # ---------------------------------------------------------------------------- #
  # Connect from Pin to Ring
  # ---------------------------------------------------------------------------- #
  #set list_ring_lay {M1 M1}
  #set pin_lay       "M1"
  #set list_net      "VSS"
  create_pg_macro_conn_pattern hm_pattern -pin_conn_type scattered_pin \
                 -layers [subst {$list_ring_lay}] -nets {VSS} -pin_layers [subst {$pin_lay}]

  set_app_options -name plan.pgroute.treat_pad_as_macro -value true

  set_pg_strategy macro_conn -macros [get_cells $list_cell] \
                 -pattern {{name: hm_pattern} {nets: {$list_net}}}
  set_pg_via_master_rule ring_m6m8 -contact_code {VIA67_1cut VIA78_1cut }

  set_pg_strategy_via_rule macro_conn_via_rule \
                -via_rule { \
                   {{{strategies: macro_conn}}{{existing: all} {layers: M1}} \
                     {via_master: ring_m6m8}} \
                    {{intersection: undefined}{via_master: NIL}} \
              }

  compile_pg -strategies macro_conn -via_rule macro_conn_via_rule -tag $tag
  remove_pg_patterns -all
  remove_pg_strategies -all
  remove_pg_strategy_via_rules -all
}

proc _pg_no_tag { _shape_use } {
  set lst_sh_no_tag {}
  set lst_v_no_tag  {}
  foreach_in_col  shape [get_shapes -f shape_use==${_shape_use} ] {
   set tag [get_attribute $shape tag];
   if {$tag!=""} {
      #puts "OK"
      continue
    } else {
      #puts "NG"
      lappend lst_sh_no_tag $shape
    }
  }
        foreach_in_col  via [get_vias -f shape_use==${_shape_use} ] {
      set tag [get_attribute $via tag];
      if {$tag!=""} {
      #puts "OK"
      continue
    } else {
      #puts "NG"
      lappend lst_v_no_tag $via
    }
  }
  
  change_selection  [get_shapes $lst_sh_no_tag]
  change_selection  [get_vias   $lst_v_no_tag ] -add
}

proc _pg_no_tag { _shape_use } {
  set lst_sh_no_tag {}
  set lst_v_no_tag  {}
  foreach_in_col  shape [get_shapes -f shape_use==${_shape_use} ] {
   set tag [get_attribute $shape tag];
   if {$tag!=""} {
      #puts "OK"
      continue
    } else {
      #puts "NG"
      lappend lst_sh_no_tag $shape
    }
  }
        foreach_in_col  via [get_vias -f shape_use==${_shape_use} ] {
      set tag [get_attribute $via tag];
      if {$tag!=""} {
      #puts "OK"
      continue
    } else {
      #puts "NG"
      lappend lst_v_no_tag $via
    }
  }
  
  change_selection  [get_shapes $lst_sh_no_tag]
  change_selection  [get_vias   $lst_v_no_tag ] -add
}

proc lb {} { puts [get_attribute [current_block ] extended_name]}

proc get_fp_info {} {
  foreach_in_col cel [get_cells [get_selection]] {
    set n [get_attr $cel full_name]
    set o [get_attr $cel orientation]
    set c [get_attr $cel origin]
    set s [get_attr $cel physical_status]
    puts "set_attribute -quiet -objects \[get_cells $n\] -name orientation -value $o"
    puts "set_attribute -quiet -objects \[get_cells $n\] -name origin -value { $c }"
    puts "set_attribute -quiet -objects \[get_cells $n\] -name status -value $s"

  }
}

proc cut_pg_frlay_tolay {{from_lay {1}} {to_lay {7}}} {
  # cut pg within bbox
  set fr_lay $from_lay; #M1
  set to_lay   $to_lay; #M7
  set bbox [get_attr [get_selection] bbox]
  set sh_rm [get_shapes -intersect [subst {$bbox}] -within [subst {$bbox}] -filter shape_use!=detail_route&&(net_type==power||net_type==ground)&&layer.mask_order_in_type>=$from_lay&&layer.mask_order_in_type<=$to_lay]
  set  v_rm [get_vias   -intersect [subst {$bbox}] -within [subst {$bbox}] -filter shape_use!=detail_route&&(net_type==power||net_type==ground)&&lower_layer.mask_order_in_type>=$from_lay&&lower_layer.mask_order_in_type<=$to_lay]
  change_selection [get_shapes $sh_rm]
  change_selection [get_vias $v_rm] -add
  split_objects $sh_rm -rect [subst {$bbox}] -force
  split_objects $v_rm  -rect [subst {$bbox}] -force
}

