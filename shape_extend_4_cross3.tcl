##### Written by ThienTran
##### This script use for extend 2 shapes for crossing with condition that 2 shape must have value "flush" for endcap attribute
##### Created on 181102
##### Update
#####   181105:         update for fixing lack shape attribute about direction when use old ICC2 version 
#####   181121:         modify this script for becoming a proc, and add bindkey for this froc
#####                   Usage: select 2 wires which want to extend to crossing point, then press Ctrl_A 



### proc get attribute of a shape: {llx lly urx ury p1x p1y p2x p2y ctx cty width length shape_name net direct angle layer}
proc attr2 {shape_name} {

set net [get_attribute [get_shapes $shape_name] owner.name]
set shape_name [get_attribute [get_shapes $shape_name] name]
set width [get_attribute [get_shapes $shape_name] width]
set length [get_attribute [get_shapes $shape_name] length]
set layer [get_attribute [get_shapes $shape_name] layer.name]
foreach {llx lly urx ury} [join [get_attribute [get_shapes $shape_name] bbox]] {}
foreach {p1x p1y p2x p2y} [join [get_attribute [get_shapes $shape_name] points]] {}
set ctx [expr $p1x/2+$p2x/2]
set cty [expr $p1y/2+$p2y/2]
if {$p1x==$p2x&&$p1y!=$p2y} {
        set direct "ver"
} elseif {$p1x!=$p2x&&$p1y==$p2y} {
        set direct "hor"
} elseif {$p1x!=$p2x&&$p1y!=$p2y} {
        set direct "dia"

}

if {$direct=="hor"&&$p1x>$p2x} {
        set t_p1x $p1x ; set t_p1y $p1y
        set p1x $p2x ; set p1y $p2y
        set p2x $t_p1x ; set p2y $t_p1y
} elseif {$direct=="ver"&&$p1y>$p2y} {
        set t_p1x $p1x ; set t_p1y $p1y
        set p1x $p2x ; set p1y $p2y
        set p2x $t_p1x ; set p2y $t_p1y
} elseif {$direct=="dia"&&$p1y>$p2y} {
        set t_p1x $p1x ; set t_p1y $p1y
        set p1x $p2x ; set p1y $p2y
        set p2x $t_p1x ; set p2y $t_p1y
        }
if {$direct=="hor"} {set angle 0
} elseif {$direct=="ver"} {set angle 90
} elseif {$direct=="dia"} {
        if {[expr $p1x-$p2x]<0} { set angle 45 } elseif {[expr $p1x-$p2x]>0} {set angle 135}
}

#echo $angle
set att_lst "$llx $lly $urx $ury $p1x $p1y $p2x $p2y $ctx $cty $width $length $shape_name $net $direct $angle $layer"
#return $llx ; return $lly ; return $urx return $ury 
#return $p1x ; return $p1y ; return $p2x return $p2y
#return $width ; return $length ; return $shape_name ; return $net ; return $direct
return $att_lst
}

#####a1x+b1=y ; a2x+b2=y
#####
proc equation_2 {a1 b1 a2 b2} {
#echo "equation of 2 variable: ${a1}x+$b1=y && ${a2}x+$b2=y"
        set x [expr ($b2-$b1)/($a1-$a2)]
        set y [expr $a2*$x+$b2]
set result [list $x $y]
#echo "value of 2 variable: {x y} = $result"
return $result
}

### stretch a selected shape from point1 (p1) to point2 (p2)
proc stretch_point {name p1x p1y p2x p2y} {
change_selection [get_shapes $name]
set p1 [list $p1x $p1y]
set p2 [list $p2x $p2y]
gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -start StretchTool
gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point $p1 -scale 0.0955
gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point $p2 -scale 0.0955
gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -reset
}


### stretch a selected shape from a point with a known-spacing 
proc stretch_space {name p1x p1y distance} {
change_selection [get_shapes $name]
set points [get_attribute [get_shapes $name] points]
set point1x [lindex $points 0 0]
set point1y [lindex $points 0 1]
set point2x [lindex $points 1 0]
set point2y [lindex $points 1 1]
set p1 [list $p1x $p1y]
set hor "" ; set ver ""
if {$point1x==$point2x} {
        set ver "true"
} elseif {$point1x!=$point2x} {
        set ver "false" 
}
if {$point1y==$point2y} {
        set hor "true"
} elseif {$point1y!=$point2y} {
        set hor "false"
}
#echo "hor $hor  ver $ver"
if {$hor=="true"&&$ver=="false"} {
        set p2 [list [expr $p1x+$distance] $p1y]
} elseif {$hor=="false"&&$ver=="true"} {
        set p2 [list $p1x [expr $p1y+$distance]]
        }
#echo " $name p1: $p1 p2: $p2 distance: $distance:"
gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -start StretchTool
gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point $p1 -scale 0.0955
gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point $p2 -scale 0.0955
gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -reset
#set p2x [lindex $p2  0]
#set p2y [lindex $p2  1]
#stretch_point $name $p1x $p1y $p2x $p2y
}
### stretch a selected shape from point1 (p1) to point2 (p2)
#proc stretch_point {name p1x p1y p2x p2y} {
#change_selection [get_shapes $name]
#set p1 [list $p1x $p1y]
#set p2 [list $p2x $p2y]
#gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -start StretchTool
#gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point $p1 -scale 0.0955
#gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -add_point $p2 -scale 0.0955
#gui_mouse_tool -window [gui_get_current_window -types Layout -mru] -reset
#}

### compare a point with shape's point (start_point, end_point) about coordinate and give flag 
proc compare_point {shape_name px py} {
### proc get attribute of a shape: {llx lly urx ury p1x p1y p2x p2y ctx cty width length shape_name net direct angle layer}
        foreach {llx lly urx ury p1x p1y p2x p2y ctx cty width length shape_name net direct angle layer} [attr2 $shape_name] {}
        if {$direct=="hor"&&$px<=$p1x} {
                set flag "left"
        } elseif {$direct=="hor"&&$px>=$p2x} {
                set flag "right"
        } elseif {$direct=="hor"&&$p1x<$px&&$px<$p2x} {
                set flag "between"
        
        } elseif {$direct=="ver"&&$py<=$p1y} {
                set flag "low"
        } elseif {$direct=="ver"&&$py>=$p2y} {
                set flag "up"
        } elseif {$direct=="ver"&&$p1y<$py&&$py<$p2y} {
                set flag "between"
        }
        return $flag
}

################################## main proc of extend 2 wires to crossing point 
proc shape_extend_4_cross {} { 

set_snap_setting -class {std_cell} -snap {litho}
set_snap_setting -class {metal_shape} -snap {litho}
set_snap_setting -class {placement_constraint} -snap {litho}
set_snap_setting -class {wiring_constraint} -snap {litho}
set_snap_setting -fix_orientation {false}
set_snap_setting -enabled {false}


foreach {sh_name1 sh_name2} [get_attribute [get_selection] name] {}

foreach {sh1_llx sh1_lly sh1_urx sh1_ury sh1_p1x sh1_p1y sh1_p2x sh1_p2y sh1_ctx sh1_cty sh1_width sh1_length sh1_shape_name sh1_net sh1_direct sh1_angle sh1_layer} [attr2 $sh_name1] {}
set sh1_start_endcap [get_attribute [get_shapes $sh_name1] start_endcap]
set sh1_end_endcap [get_attribute [get_shapes $sh_name1] end_endcap]
set sh1_shape_use [get_attribute [get_shapes $sh_name1] shape_use]

foreach {sh2_llx sh2_lly sh2_urx sh2_ury sh2_p1x sh2_p1y sh2_p2x sh2_p2y sh2_ctx sh2_cty sh2_width sh2_length sh2_shape_name sh2_net sh2_direct sh2_angle sh2_layer} [attr2 $sh_name2] {}
set sh2_start_endcap [get_attribute [get_shapes $sh_name2] start_endcap]
set sh2_end_endcap [get_attribute [get_shapes $sh_name2] end_endcap]
set sh2_shape_use [get_attribute [get_shapes $sh_name2] shape_use]


if {$sh1_direct=="hor"&&$sh2_direct=="ver"} {
        set p_com [list $sh2_p1x $sh1_p1y]
} elseif {$sh1_direct=="ver"&&$sh2_direct=="hor"} {
        set p_com [list $sh1_p1x $sh2_p1y]
        }
set p_com_x [lindex $p_com 0]
set p_com_y [lindex $p_com 1]

set sh1_flag [compare_point $sh1_shape_name $p_com_x $p_com_y]
set sh2_flag [compare_point $sh2_shape_name $p_com_x $p_com_y]

#echo "sh1_flag: $sh1_flag sh2_flag: $sh2_flag"
if {$sh1_start_endcap=="flush"&&$sh1_end_endcap=="flush"&&$sh2_start_endcap=="flush"&&$sh2_end_endcap=="flush"} {

        if {$sh1_flag=="left"||$sh1_flag=="low"} {
                stretch_point $sh1_shape_name $sh1_p1x $sh1_p1y $p_com_x $p_com_y
                stretch_space $sh1_shape_name $p_com_x $p_com_y [expr -1*$sh2_width/2]
        } elseif {$sh1_flag=="right"||$sh1_flag=="up"} {
                stretch_point $sh1_shape_name $sh1_p2x $sh1_p2y $p_com_x $p_com_y
                stretch_space $sh1_shape_name $p_com_x $p_com_y [expr $sh2_width/2]
        }               

        if {$sh2_flag=="left"||$sh2_flag=="low"} {
                stretch_point $sh2_shape_name $sh2_p1x $sh2_p1y $p_com_x $p_com_y
                stretch_space $sh2_shape_name $p_com_x $p_com_y [expr -1*$sh1_width/2]
        } elseif {$sh2_flag=="right"||$sh2_flag=="up"} {
                stretch_point $sh2_shape_name $sh2_p2x $sh2_p2y $p_com_x $p_com_y
                stretch_space $sh2_shape_name $p_com_x $p_com_y [expr $sh1_width/2]
        }
}

change_selection [get_shapes $sh1_shape_name] -add
set_snap_setting -enabled {true}
}

#################binkey for running the proc of  stretching wires to  crossing point
gui_set_hotkey -hot_key "Ctrl+A" -replace -tcl_cmd {
        shape_extend_4_cross
   }


