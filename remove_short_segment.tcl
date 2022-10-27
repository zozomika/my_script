
set outfile [open rm_segment_only_with_short_drc.tcl w]

foreach_in_collection drc_err [get_drc_errors -error_data [get_drc_error_data ] -filter {type_name==Short}]  {
    set drc_layer [get_attr [get_attr $drc_err layers] name]
    set drc_bbox "{[get_attr $drc_err bbox]}"
    set short_shapes [get_shapes -intersect $drc_bbox -filter "layer_name==$drc_layer"]
    foreach_in_collection shape $short_shapes {
        set net_type [get_attr $shape net_type]
        if { $net_type == "power" || $net_type == "ground" } { continue }
        set physical_status [get_attr $shape physical_status]
        if { $physical_status == "fixed" || $physical_status == "locked" } { continue }
        puts $outfile "remove_shapes -force \[get_shapes [get_attr $shape name]\]"
    }
}
close $outfile
