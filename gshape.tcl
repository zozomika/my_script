proc gshape {space vertical left_bottom} {
        set pins [get_pins [get_selection]]
        set layer M4
        set width 0.22
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
                        gui_set_mouse_tool_option -tool CreateRouteTool -option {AutoWelding} -value {false}
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
                                if {$left_bottom == 1}
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

####################
proc ch {new_name} {
        foreach_in_col via [get_vias [get_selection]] {
                set old_name  [get_attribute [get_vias $via] owner]
                remove_from_net $old_name [get_vias $via]
                add_to_net $new_name [get_vias $via]
        }
        foreach_in_col shape [get_shapes [get_selection]] {
                set old_name  [get_attribute [get_shapes $shape] owner]
                remove_from_net $old_name [get_shapes $shape]
                add_to_net $new_name [get_shapes $shape]
        }
}
