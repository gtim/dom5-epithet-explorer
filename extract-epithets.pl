#
# extracts epithets from game binary
#


use 5.26.0;
use warnings;
use experimental qw/switch/;

use File::Slurper qw/read_binary write_text/;
use JSON qw//;

my $FILENAME_EXE_X64 = 'Dominions554-64.exe';
my $FILENAME_EPITHETS_OUT = 'src/epithets.json';

my $IMAGEBASE_OFFSET = 0x2200;
my $EPITHETS_OFFSET = 0x13533b4+12 - $IMAGEBASE_OFFSET; 
my $EPITHET_LENGTH = 0x20;

my $blob = read_binary( $FILENAME_EXE_X64 );

# Read all epithets
# TODO: find number of epithets from binary

my @epithets;
for my $epithet_i ( 0..745 ) {
	my $epithet_bytes = substr( $blob, $EPITHETS_OFFSET + $epithet_i * $EPITHET_LENGTH, $EPITHET_LENGTH );
	my ( $name_offset, @conditions_and_values ) = unpack 'Q<'.('S<'x12), $epithet_bytes;
	my $name = get_cstring( $blob, $name_offset - $IMAGEBASE_OFFSET - 0x140000000 );

	my @conditions = @conditions_and_values[0..5];
	my @values = @conditions_and_values[6..11];

	my $pret_str = sprintf "%3d: %s\n", $epithet_i, $name;
	my $epithet = { id => $epithet_i, string => $name, constraints => [] }; 
	for my $con_i ( 0..5 ) {
		my ( $con, $val ) = ( $conditions[$con_i], $values[$con_i] );
		my $constr = constraint_hash( $con, $val );
		push @{$epithet->{constraints}}, $constr if $constr;
	}
	push @epithets, $epithet;
}

# Add special "Ruler of Nothing" epithet
# TODO: Add a sanity check to make sure the string exists in the binary

push @epithets, {
	id => -1, 
	string => "Ruler of Nothing",
	constraints => [ { 
		type => 'default', 
		value => 0,
	} ]
};

# Output epithets.json

my $json = JSON->new->canonical->pretty;
my $epithets_json = $json->encode( { epithets => \@epithets } );
write_text( $FILENAME_EPITHETS_OUT, $epithets_json );


# misc stuff

if(0){
	# Titles in front of epithets.
	# Available to all: God, Lord, Master (male) and Goddess, Lady, Mistress
	# Available to TC (any age): Emperor, Minister and Empress, Minister
	# Available to Yomi/Shinuyama/Jomon: Emperor, Emperor and Empress, Empress (i.e. twice the chance)
	# Available to those not TC or Yomi/Shinu/Jomon: King, Prince and Queen, Princess

	# Tien Chi titles
	say join ', ', get_titles( $blob, 0x135f650, 5 ); # male
	say join ', ', get_titles( $blob, 0x135f678, 5 ); # female
	# Yomi/shinu/jomon titles
	say join ', ', get_titles( $blob, 0x135f6a0, 5 ); # male
	say join ', ', get_titles( $blob, 0x135f6c8, 5 ); # female
	# All other nations' titles
	say join ', ', get_titles( $blob, 0x135f600, 5 ); # male
	say join ', ', get_titles( $blob, 0x135f628, 5 ); # female


	# Ruler of Nothing: no epithets found after 10,000 tries
	say get_cstring( $blob, 0x135f5e8 - $IMAGEBASE_OFFSET );

}

sub constraint_hash {
	my ( $con, $val ) = @_;
	given ( $con ) {

		when (0) { return; }

		# Unique: No other epithets of this category can be chosen
		when (   4) { return {'type' => 'unique', value => $val} }

		# Nation
		when (   3) { return {'type' => 'nation', value => $val } }

		# mnr / chassis
		when (  18) { return {'type' => 'chassis', value => $val } }

		# Gender
		when (   2) {
			if ( $val == 0 ) {
				return {'type' => 'gender', value => 'female' }
			} elsif ( $val == 1 ) {
				return {'type' => 'gender', value => 'male' }
			} else {
				die "valid gender unhandled";
			}
		}
		when (  19) {
			if ( $val == 0 ) {
				return {'type' => 'team leader gender', value => 'female' }
			} elsif ( $val == 1 ) {
				return {'type' => 'team leader gender', value => 'male' }
			} else {
				die "valid gender but unhandled";
			}
		}

		# Boolean
		when (  11) { return {'type' => 'boolean', 'field' => 'undead',    'value' => $val } }
		when (  12) { return {'type' => 'boolean', 'field' => 'demon',     'value' => $val } }
		when (  14) { return {'type' => 'boolean', 'field' => 'immortal',  'value' => $val } }
		when (  15) { return {'type' => 'boolean', 'field' => 'immobile',  'value' => $val } }
		when (  16) { return {'type' => 'boolean', 'field' => 'inanimate', 'value' => $val } }
		when (  17) { return {'type' => 'boolean', 'field' => 'disciple',  'value' => $val } }

		# Misc.
		when (   1) { return {'type' => 'misc minimum', field => 'dominion strength', 'value' => $val } }
		when (   5) { return {'type' => 'misc minimum', field => 'fear',              'value' => $val } }
		when (   6) { return {'type' => 'misc minimum', field => 'awe',               'value' => $val } }
		when (   7) { return {'type' => 'misc minimum', field => 'strength',          'value' => $val } }
		when (  20) { return {'type' => 'misc minimum', field => 'eyes',              'value' => $val+2 } }

		# Minimum magic path
		when (1000) { return {'type' => 'magic path', 'field' => 'F', 'value' => $val } }
		when (1001) { return {'type' => 'magic path', 'field' => 'A', 'value' => $val } }
		when (1002) { return {'type' => 'magic path', 'field' => 'W', 'value' => $val } }
		when (1003) { return {'type' => 'magic path', 'field' => 'E', 'value' => $val } }
		when (1004) { return {'type' => 'magic path', 'field' => 'S', 'value' => $val } }
		when (1005) { return {'type' => 'magic path', 'field' => 'D', 'value' => $val } }
		when (1006) { return {'type' => 'magic path', 'field' => 'N', 'value' => $val } }
		when (1007) { return {'type' => 'magic path', 'field' => 'B', 'value' => $val } }
		when (1051) { return {'type' => 'magic paths', field => 'FAWE',      'value' => $val } }
		when (1052) { return {'type' => 'magic paths', field => 'SDNB',      'value' => $val } }
		when (1053) { return {'type' => 'magic paths', field => 'FAWESDNB',  'value' => $val } }


		# Max scale
		when (2000) { return { 'type' => 'scale', 'field' => 'Turmoil',      value => $val } }
		when (2001) { return { 'type' => 'scale', 'field' => 'Sloth',        value => $val } }
		when (2002) { return { 'type' => 'scale', 'field' => 'Cold',         value => $val } }
		when (2003) { return { 'type' => 'scale', 'field' => 'Death',        value => $val } }
		when (2004) { return { 'type' => 'scale', 'field' => 'Misfortune',   value => $val } }
		when (2005) { return { 'type' => 'scale', 'field' => 'Drain',        value => $val } }

		# Min scale
		when (2100) { return { 'type' => 'scale', 'field' => 'Order',        value => $val } }
		when (2101) { return { 'type' => 'scale', 'field' => 'Productivity', value => $val } }
		when (2102) { return { 'type' => 'scale', 'field' => 'Heat',         value => $val } }
		when (2103) { return { 'type' => 'scale', 'field' => 'Growth',       value => $val } }
		when (2104) { return { 'type' => 'scale', 'field' => 'Luck',         value => $val } }
		when (2105) { return { 'type' => 'scale', 'field' => 'Magic',        value => $val } }

		default { die "unhandled condition: $con=$val"; }
	}
}

sub get_titles {
	my ( $blob, $start, $num_titles ) = @_;
	my @title_offsets = unpack 'Q<'x5, substr($blob, $start - $IMAGEBASE_OFFSET, 8*$num_titles  );
	my @titles = map { get_cstring( $blob, $_ - $IMAGEBASE_OFFSET - 0x140000000 ) } @title_offsets;
	return @titles;
}

# convenience functions

sub get_cstring {
	my ( $blob, $start ) = @_;
	my $end = index( $blob, chr(0), $start );
	die "could not find end of c string" if $end == -1;
	die "suspiciously long epithet (".($end-$start).")" if $end - $start > 70;
	return substr( $blob, $start, $end-$start );
}
