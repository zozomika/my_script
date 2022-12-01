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

