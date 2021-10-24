#
# extracts epithets from game binary
#


use 5.26.0;
use warnings;

use File::Slurper qw/read_binary/;

my $FILENAME_EXE_X64 = 'Dominions554-64.exe';

my $IMAGEBASE_OFFSET = 0x2200;
my $EPITHETS_OFFSET = 0x13533b4+12 - $IMAGEBASE_OFFSET; 
my $EPITHET_LENGTH = 0x20;

my $blob = read_binary( $FILENAME_EXE_X64 );

for my $epithet_i ( 0..20, 323 ) {
#for my $epithet_i ( 0..745 ) {
	my $epithet_bytes = substr( $blob, $EPITHETS_OFFSET + $epithet_i * $EPITHET_LENGTH, $EPITHET_LENGTH );
	my ( $name_offset, @conditions_and_values ) = unpack 'Q'.('S'x12), $epithet_bytes;
	my $name = get_cstring( $blob, $name_offset - $IMAGEBASE_OFFSET - 0x140000000 );

	my @conditions = @conditions_and_values[0..5];
	my @values = @conditions_and_values[6..11];

	printf "%3d: %s\n", $epithet_i, $name;
	for my $con_i ( 0..5 ) {
		my ( $con, $val ) = ( $conditions[$con_i], $values[$con_i] );
		my $constr;
		given ( $con ) {

			when (0) { next }

			when (   1) { $constr = "Dom. Str.  >= $val"; }

			when (1000) { $constr = "Fire       >= $val"; }
			when (1001) { $constr = "Air        >= $val"; }
			when (1002) { $constr = "Water      >= $val"; }
			when (1003) { $constr = "Earth      >= $val"; }
			when (1004) { $constr = "Astral     >= $val"; }
			when (1005) { $constr = "Death      >= $val"; }
			when (1006) { $constr = "Nature     >= $val"; }
			when (1007) { $constr = "Blood      >= $val"; }

			when (2100) { $constr = "Order      >= $val"; }
			when (2101) { $constr = "Production >= $val"; }
			when (2102) { $constr = "Heat       >= $val"; }
			when (2103) { $constr = "Growth     >= $val"; }
			when (2104) { $constr = "Luck       >= $val"; }
			when (2105) { $constr = "Magic      >= $val"; }

			default { $constr = sprintf "?? %d: %d", $con, $val; }
		}
		say '     '.$constr;
	}
	print "\n";
}

sub get_cstring {
	my ( $blob, $start ) = @_;
	my $end = index( $blob, chr(0), $start );
	die "could not find end of c string" if $end == -1;
	die "suspiciously long epithet (".($end-$start).")" if $end - $start > 70;
	return substr( $blob, $start, $end-$start );
}
