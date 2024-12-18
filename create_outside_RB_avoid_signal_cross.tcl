#create_outside_RB_avoid_signal_cross.tcl
proc gcreate_RB_avoid_signal_pin_of_cell {args} {
  parse_proc_arguments -args $args pargs
  set RV28F 1
  if {[info exists pargs(-from_lay)]} {
    set lay1 $pargs(-from_lay)
  } else { set lay1 2 }
  if {[info exists pargs(-to_lay)]} {
    set lay2   $pargs(-to_lay)
  } else { set lay2 7 }
  if {[info exists pargs(-full_cover_lay)]} {
    set lay3   $pargs(-full_cover_lay)
  }
  
  if {[info exists pargs(-offset)]} {
    set offset $pargs(-offset)
  } else { set offset 0 }
  set targets $pargs(-cell)
  # Trace instances of provided target cell
  set all_tgt_IP ""
  foreach obj $targets {
    set flag_on 1
    set all_tgt_IP [get_db [get_db insts -if {.base_cell.name == $obj} ] .name]
    if {$all_tgt_IP == ""} {puts "ERROR: Cannot find $obj"}
    foreach ip $all_tgt_IP {
      set ip_pin_shape ""
      set inst         [dbget -p1 top.insts.name $ip]
      set inst_polygon [dbShape [dbget $inst.boxes]]
      set ip_pin [dbget $inst.cell.terms]
      set ip_pin_shape [dbget $ip_pin.pins.allShapes]
      foreach inst_box  $inst_polygon {
        set inst_resize  [dbShape -output rect $inst_box SIZE $offset]
        # Get IP coordinate
        set ip_llx [lindex $inst_box 0];
        set ip_lly [lindex $inst_box 1];
        set ip_urx [lindex $inst_box 2];
        set ip_ury [lindex $inst_box 3];
        set actual_shape ""
        set index_sh 0
        # Main script
        # Get pin shapes (signal type)
        foreach shape $ip_pin_shape {
          array set distance [list {lef} "" {bot} "" {rig} "" {top} ""]
          set extracted_shape ""
          if {[lsort -unique [dbget $shape.shapes.type]] == "rect"} {
            set extracted_shape [dbget $shape.shapes.rect]
          } elseif {[lsort [dbget $shape.shapes.type]] == "poly"} {
            set extracted_shape [dbget $shape.shapes.poly]
          } else {
            puts "ERROR: Invailid Pin shape of ip $ip"
            puts [dbget $shape.shapes.rect]
          }
          set lay_shape [lindex [dbget $ip_pin_shape.layer.name] $index_sh]  ; #get corresponding layer of pin shape
          set actual_shape [dbTransform -localPt $extracted_shape -inst $ip] ; #convert local coordinate to global coordinate
          if {$lay_shape != "alpad" && $lay_shape != "pass"} {
            foreach ashape $actual_shape {
              set actual_shape_llx [lindex $ashape 0]
              set actual_shape_lly [lindex $ashape 1]
              if {$actual_shape_llx >= $ip_llx && $actual_shape_llx <= $ip_urx && $actual_shape_lly >= $ip_lly && $actual_shape_lly <= $ip_ury} {
                # Check distance between pin and macro boundary: 
                set distance(lef) [expr abs( $actual_shape_llx - $ip_llx)]
                set distance(bot) [expr abs( $actual_shape_lly - $ip_lly)]
                set distance(rig) [expr abs( $actual_shape_llx - $ip_urx)]
                set distance(top) [expr abs( $actual_shape_lly - $ip_ury)]
                set my_distance distance(lef)
                foreach {key value} [array get distance] {
                  if { $value <= $my_distance} {
                    set my_distance $value
                    set my_key $key
                  }
                }
                switch $my_key {
                  lef { set ashape_resize [dbShape -output rect $ashape SIZEX $offset] }
                  bot { set ashape_resize [dbShape -output rect $ashape SIZEY $offset] }
                  rig { set ashape_resize [dbShape -output rect $ashape SIZEX $offset] }
                  top { set ashape_resize [dbShape -output rect $ashape SIZEY $offset] }
                  default { puts "ERROR: Invailid $key"}
                }
                # Create Blockage
                set inst_resize [dbShape -output polygon $inst_resize  ANDNOT $ashape_resize]
              } else { continue }
            }
          }
          incr index_sh 
        }
      set inst_resize [dbShape -output rect [dbget top.fplan.box] AND $inst_resize]
      foreach s [dbShape $inst_resize] {
        createRouteBlk -name RB_analog_HM -box $s -cutLayer all -exceptpgnet -layer all
      }
      ## Create RB
      #for {set i $lay1} {$i <= 3} {incr i} {
      #  if {($i <= 10) || ($i == "AP")} { set lay "AP" } else { set lay [subst {M$i}]}
      #  if {$flag_on && ($lay3 != "")} {
      #    puts "DEBUG: createRouteBlk -name RB_analog_HM -inst $ip -layer $lay3"
      #    set flag_on 0
      #  }
      #}
      }
    }
  }
}

define_proc_arguments gcreate_RB_avoid_signal_pin_of_cell -info "Create and display routing blockages inside initial object areas" \
  -define_args {
    {-from_lay       "layer help"  Alayer1    int       optional}
    {-to_lay         "layer help"  ALayer2    int       optional}
    {-full_cover_lay "layer help"  ALayer3    list      optional}
    {-offset         "offset help" AOffset    float     optional}
    {-cell           "target help" AList      list      required}
  }
