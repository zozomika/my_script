####### CHECK WIRE LENGTH AND FANOUT LSC #########

set LSC_CELLS "
top/top_c5/padw/pamw/PL_IO_IOBUF_LSC_PAD_0074 
top/top_c5/padw/pamw/PL_IO_IOBUF_LSC_PAD_ISO_0075 
vio/vio_c4_sub/lvd0/lv1_lvd_u7790mlvd000hm0_PL_IO_LSC_VCCQ_LVDS_VIO
top/top_c5/padw/pamw/PL_IO_IOBUF_BUFF33_1_0044 
top/top_c5/padw/pamw/PL_IO_IOBUF_BUFF33_2_0046 
top/top_c5/padw/pamw/PL_IO_IOBUF_BUFF33_3_0047
top/top_c5/pade/pame/PL_IO_IOBUF_BUFF33_5_0048 
top/top_c5/pade/pame/PL_IO_IOBUF_BUFF18_6_0042 
top/top_c5/pade/pame/PL_IO_IOBUF_BUFF33_7_0049
top/top_c5/pade/pame/PL_IO_IOBUF_BUFF33_8_0050 
top/top_c5/pade/pame/PL_IO_IOBUF_BUFF18_9_0043
top/top_c5/padw/pamw/PL_IO_IOBUF_BUFF33_10_0045
hsc/hsc_a3hsc/us2phy0/USB20IP/XCVR
hsc/hsc_a3hsc/us2phy1/USB20IP/XCVR
"
set VSWC_CELLS "
top/top_nonfb/swc/lsdown_cdrn_buf0 
top/top_nonfb/swc/lsdown_cdrn_buf1 
top/top_nonfb/swc/lsdown_re_buf0 
top/top_nonfb/swc/lsdown_re_buf1 
top/top_nonfb/swc/lsup_cdsn_buf0 
top/top_nonfb/swc/lsup_cdsn_buf1
top/top_nonfb/swc/lsup_se_buf0 
top/top_nonfb/swc/lsup_se_buf1
"

set THS "
top/top_c4/ths0/ths_macro
"
#set LSC_CELLS "
#vio_c4/lvd0/lv1_lvd_u7790mlvd000hm0_PL_IO_LSC_VCCQ_LVDS_VIO \
#vio_c4/PL_IO_vio_lscbuf \
#"
foreach lsc_inst $LSC_CELLS {
        puts "########################################################################################"
        puts [format "%s %-80s %s" "###" "$lsc_inst" "###"]
        puts "########################################################################################"
        puts [format "%-40s %-15s %-15s %-30s" "Net name" "Fanout" "Direction" "Total Length"]
        #puts [format "%-40s %-10s %-10s %-10s %-30s" "Net name" "Fanout" "Dont_touch" "Direction" "Total Length"]
        foreach_in_col p [get_pins -of [get_cells $lsc_inst] -filter "direction!=inout"] {
            #set pin_name [get_pins $p]
            set pin_name  [get_attr [get_pins $p] full_name]
            set direction  [get_attr [get_pins $p] direction]
            set net_name [get_attr [get_nets -of [get_pins $p] -f "full_name!~*VDD*&&full_name!~*VSS*" -quiet] full_name ]
            #set net_name [get_attr [get_nets -of [get_pins $p] -quiet -segment -physical_context] full_name ]
	    if {$net_name!= ""} {
	       set fanout   [expr [sizeof_collection [all_connected -leaf [get_nets  $net_name]]] - 1]
               #change_selection [get_shapes -f net.name==$net_name]
               set total_leng 0
               if { $fanout > 0 } {
                  set route_leng [get_attr [get_nets $net_name -f "route_length!=0" -quiet]  route_length]
                  foreach lay_leng $route_leng {
                     set total_leng [expr $total_leng + [lindex $lay_leng 1]]
                  }
                }   
	        if { ([string match $net_name {VDD}] || [string match $net_name {VSS}] || [string match $net_name {VDDQ18_1}] || [string match $net_name {VDDQ33_1}] || [string match $net_name {VSSQ}] )
		      || [string match $net_name {VDDQ18_0}] || [string match $net_name {VDDQ18_ISO}]  } {
		} else { 
                   if { $fanout > 0 } {
                        set dont_touch  [get_attr -quiet [get_nets $net_name ] dont_touch ]
		        #puts [format "%-30s %-30s " "Net: $net_name"  "Route Length: $route_leng"]
                        puts [format "%-40s %-15s %-15s %-30s" "$net_name" "$fanout" "$direction" "$total_leng"]
		        #puts [format "%-40s %-10s %-10s %-10s %-30s" "$net_name" "$fanout" "$dont_touch" "$direction" "$total_leng"]
                        #puts "Net: $net_name Fanout: $fanout Length: $total_leng"
                   }
                }
	    }
	}
}
