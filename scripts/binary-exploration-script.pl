use 5.24.0;

#
# short script ot test optimized conditionals from the binary
#

# from binary: (param_nation_id - 0x1b < 0x3f) && ((0x4000002000000001U >> ((ulonglong)(param_nation_id - 0x1b) & 0x3f) & 1) != 0)
# output:
# 27	EA Yomi
# 64	MA Shinuyama
# 89	LA Jomon

for my $nat_id (0..250) {
	next unless $nat_id - 0x1b >= 0 && $nat_id - 0x1b < 0x3f; # 27..89
	next unless ( 0x4000002000000001 >> ( $nat_id - 0x1b ) & 0x3f ) & 1;
	say $nat_id;
}

