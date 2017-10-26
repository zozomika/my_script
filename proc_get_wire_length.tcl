### get wire leng report of list net was defind in file list_net



proc gget_wire_length { list_signal } {
  set list_metal [ list M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 AP]

#set list_name [dbget selected.net.name]
#echo $list_name > list_name
#cat list_name | sed '-e s/$/ \n/g' | sed '-e s/ / \\\n/g' | sort -u >! list_net
#source list_net_ddr
#source list_net_rdl
#set list_signal [dbget selected.net.name]
  set header  "net "
  foreach LAY $list_metal {
                lappend  header  "\t $LAY (width) " 
        } 
  echo "$header"
  foreach net $list_signal {
	deselectAll
	editSelect -net $net
	foreach LAY $list_metal {
		set net_width($LAY) 0.0
		set net_length($LAY) 0.0
	}
	foreach shape  [dbget selected] {
		if { [dbget $shape.width] != 0 } {
	
			set shape_width [format %.3f [dbget $shape.width]]
			set shape_layer [dbget $shape.layer.name]
			if { $shape_width <=  $net_width($shape_layer) || $net_width($shape_layer) == 0.0} {
				set net_width($shape_layer) $shape_width
			}
			set llx [dbGet $shape.box_llx]
			set lly [dbGet $shape.box_lly]
			set urx [dbGet $shape.box_urx]
			set ury [dbGet $shape.box_ury]
			set vertical [format %.3f [expr $urx - $llx]]
			set hozizontal [format %.3f [expr $ury - $lly]]
			if { $vertical == $shape_width } { 
				set shape_length [expr $ury - $lly]
			} elseif {$hozizontal == $shape_width} {	 
				set shape_length  [expr $urx - $llx]
			} elseif { ($vertical != $shape_width) && ( $hozizontal != $shape_width)} {
				set shape_length  [format %.2f [expr ($urx - $llx) * 1.4142 - ($shape_width * 1.4142)]]
			} else { 
			}
			set net_length($shape_layer) [expr $net_length($shape_layer) + $shape_length]
		}
	}
	set rpt_length "$net "
	set a $net_width(M11)
	if { $a !=10.5 } {
	set net_length(M11) [expr $net_length(M11) /2]
	set net_width(M11)  [expr  $net_width(M11) *2]
	}
        set total_length 0
	foreach LAY $list_metal {
		lappend  rpt_length "\t $net_length($LAY) ($net_width($LAY)) " 
               set total_length [expr $total_length + $net_length($LAY) ]
	}

	echo "$rpt_length  $total_length"
#	return $total_length
	
  }
}
