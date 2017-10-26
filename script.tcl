####### CHECK WIRE LENGTH AND FANOUT LSC #########

set LSC_CELLS "
top/padr/pamr/PL_IO_LSC_PAD_0166 \
top/padu/pamu/PL_IO_lscbuf33_0_0167 \
top/padl/paml/PL_IO_lscbuf33_2_0169 \
top/padl/paml/PL_IO_lscbuf33_3_0170 \
top/padu/pamu/PL_IO_lscbuf33_1_0168 \
top/padr/pamr/PL_IO_lscbuf33_0_0171 \
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
#set LSC_CELLS "
#vio_c4/lvd0/lv1_lvd_u7790mlvd000hm0_PL_IO_LSC_VCCQ_LVDS_VIO \
#vio_c4/PL_IO_vio_lscbuf \
#"
#foreach lsc_inst $VSWC_CELLS {
##        puts "##################################################################"
##        puts "### $lsc_inst"
##        puts "##################################################################"
#        foreach_in_col p [get_pins -of [get_cells $lsc_inst] -filter "direction!=inout"] {
#            #set pin_name [get_pins $p]
#            set pin_name  [get_attr [get_pins $p] full_name]
#            #set net_name [get_attr [get_nets -of [get_pins $p] -f "full_name!~*VDD*&&full_name!~*VSS*" -quiet] full_name ]
#            set net_name [get_attr [get_nets -of [get_pins $p] -quiet -segment -physical_context] full_name ]
#	    if {$net_name!= ""} {
#	       set fanout   [expr [sizeof_collection [all_connected -leaf [get_nets  $net_name]]] - 1]
#               #change_selection [get_shapes -f net.name==$net_name]
#               set total_leng 0
#               if { $fanout > 0 } {
#                  set route_leng [get_attr [get_nets $net_name -f "route_length!=0" -quiet]  route_length]
#                 # foreach lay_leng $route_leng {
#                 #    set total_leng [expr $total_leng + [lindex $lay_leng 1]]
#                 # }
#                }   
#	        if { ([string match $net_name {VDD}] || [string match $net_name {VSS}] || [string match $net_name {VDDQ18_1}] || [string match $net_name {VDDQ33_1}] || [string match $net_name {VSSQ}] )
#		      || [string match $net_name {VDDQ18_0}]  } {
#		} else { 
#		   puts [format "%-30s %-30s " "Net: $net_name"  "Route Length: $route_leng"]
#		   #puts [format "%-30s %-30s %-30s" "Net: $net_name" "Fanout: $fanout" "Total Length: $total_leng"]
#                   #puts "Net: $net_name Fanout: $fanout Length: $total_leng"
#                }
#	    }
#	}
#}
