#! /usr/bin/perl - w - c
#################################################################################################
# NAME                                                                                          #
#       check_cp_file.pl                                                                        #
#                                                                                               #
# USAGE                                                                                         #
#       check_cp_file.pl <reference_data> <checking_data>                                       #
#	check_cp_file.pl -file <file name>							#
#		+file format									#
#			reference_data1 checking_data1						#
#			reference_data2 checking_data2						#
#			...									#
#                                                                                               #
# DESCRIPTION                                                                                   #
#       Compare md5sum of reference file and checking file.                                    	#
#                                                                                               #
# AUTHOR                                                                                        #
#       Written by Nguyen Huy Binh (RVC - 1358)                                                 #
#                                                                                               #
# REPORTING BUGS                                                                                #
#       Report bugs to <binh.nguyen.wz@rvc.renesas.com>                                         #
#                                                                                               #
# DATE                                                                                          #
#       16-June-2017                                                                           	#
#################################################################################################

################################################################
$version = "1.0";
################################################################


$file_enable = 0;

if (@ARGV !=  0) {
	while ($ARGV[0] =~ /^-file$/) {
		$file_enable = 1;
		shift(@ARGV);
		$file_name = $ARGV[0];
	}
}

if ($file_enable == 1) {
	if ($file_name =~ /.gz$/) {
		open(FILE_NAME,"zcat $file_name |");
	} else {
		open(FILE_NAME,"$file_name");
	}
	while ( $line = <FILE_NAME> ) {
		if ($line =~ /^\s*$/) {
			next;
		}
		@cut_line = split(/\s+/,$line);
		$reference_data = $cut_line[0];
		$checking_data  = $cut_line[1];
		compare_data($reference_data,$checking_data);
	}
	close (FILE_NAME)

} else {
	$reference_data = $ARGV[0];
	shift(@ARGV);
	$checking_data = $ARGV[0];
	shift(@ARGV);
	compare_data($reference_data,$checking_data);
}

sub compare_data {
	my ($reference_data, $checking_data) = @_;
	$md5sum_reference_data = `md5sum $reference_data`;
	print ("$md5sum_reference_data");
	$md5sum_checking_data  = `md5sum $checking_data` ;
	print ("$md5sum_checking_data");
	@cut_md5sum_reference_data = split(/\s+/,$md5sum_reference_data);
	@cut_md5sum_checking_data  = split(/\s+/,$md5sum_checking_data);
	if ($cut_md5sum_reference_data[0] eq $cut_md5sum_checking_data[0]) {
		print ("Compare: MATCHED\n\n");
	} else {
		print ("Compare: UNMATCHED\n\n");
	}
}
