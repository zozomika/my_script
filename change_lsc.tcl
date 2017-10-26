#get_attr [get_nets LSC_SE_05] route_length
#script to list net_name pin_name fanout total_leng of LSC cell

set LSC_CELLS "
top/padr/pamr/PL_IO_LSC_PAD_0166 \
top/padu/pamu/PL_IO_lscbuf33_0_0167 \
top/padl/paml/PL_IO_lscbuf33_2_0169 \
top/padl/paml/PL_IO_lscbuf33_3_0170 \
top/padu/pamu/PL_IO_lscbuf33_1_0168 \
top/padr/pamr/PL_IO_lscbuf33_0_0171 \
"

#set LSC_CELLS "
#vio_c4/lvd0/lv1_lvd_u7790mlvd000hm0_PL_IO_LSC_VCCQ_LVDS_VIO \
#vio_c4/PL_IO_vio_lscbuf \
#"
foreach lsc_inst $LSC_CELLS { 

  #puts "##################################################################"
  #puts "### $lsc_inst"
  #puts "##################################################################"

  #foreach_in_col p [get_pins -of [get_cells $lsc_inst] -filter "direction==out"] {
  foreach_in_col p [get_pins -of [get_cells $lsc_inst]] {

    #set pin_name [get_pins $p]
    set pin_name  [get_attr [get_pins $p] full_name]
    #puts "test pin: $pin_name"
    set net_name [get_attr [get_nets -of [get_pins $p] -physical_context] full_name] 
    #puts "test net: $net_name "
    set fanout   [expr [sizeof_collection [all_connected -leaf [get_nets $net_name]]] - 1]
    #change_selection [get_net_shapes -f owner_net==$net_name]
    set total_leng 0
    if { $fanout > 0 } {
      set route_leng [get_attr [get_nets $net_name] route_length]
     # puts "tim net: $net_name"
      puts "Net_name: $net_name Layer: $route_leng"
      #foreach 
      set lay_leng [lindex $route_leng 0] 
      #{
      # puts "test:  $lay_leng"
       set aaa [lindex $lay_leng 1]
      # puts "test: $aaa"
       set total_leng [expr $total_leng + $aaa]
      # puts "tinh: $total_leng"
     # }
    }
    puts "Net_name: $net_name  Fanout: $fanout Length: $total_leng"
    #puts "$net_name  $fanout"

  }
}

#foreach lsc_inst $LSC_CELLS {
#   foreach_in_col p [get_pins -of [get_cells $lsc_inst] -filter "direction==out"] {
#      #set pin_name  [get_attr [get_pins $p] full_name]
#      #puts "test pin: $pin_name"
#      set net_name [get_attr [get_nets -of [get_pins $p] -segment] full_name]
#      set attribute [get_attr [get_nets -of [get_pins $p] -segment] dont_touch]
#      puts "test: $net_name $attribute" 
#      #puts "test: $attribute" 
#   }
#}

