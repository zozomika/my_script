#Prepare spec_text_lis_sorted
cat spec_text_lis | awk ' {print $3 " " $6 " " $7} ' | sed -e ' s/VSS18_THS/VSSQ_THS/g' -e ' s/VDD18_THS/VDDQ18_THS/g' -e 's/EFUSE_MON1/EFUSE_VDDQ/g' -e 's/EFUSE_MON2/EFUSE_VDDQ/g' | sort -u > ! spec_text_lis_sorted


#Prepare text_lis_sorted
cat text.lis | awk ' {printf "%s %.2f %.2f\n", $3, $4, $5} ' | sed ' s/\"//g ' | sort -u > ! text_lis_sorted
