#------------------------------------------------------------------------------------------------
# v02-00 : support multiple run
#------------------------------------------------------------------------------------------------
set outfile [open cut_internal_pg_pin_for_verilog.tcl w]
set target_pins [get_pins -hier -filter {port_type==power&&pg_type==internal&&direction==in} -q]

if {[sizeof $target_pins] > 0} {
   foreach_in_collection pin $target_pins {
       set pin_name [get_attr $pin full_name]
       set net [get_nets -q -of $pin]
       if {[sizeof $net] > 0} {
           set net_name [get_attr $net full_name]
           puts      ">>> disconnect_net $net_name $pin_name"
           puts $outfile "disconnect_net $net_name $pin_name"
       }
   }
   close $outfile
   source cut_internal_pg_pin_for_verilog.tcl
}
#eof
