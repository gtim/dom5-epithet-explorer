#
# extracts epithets from game binary
#


use 5.26.0;
use warnings;

use File::Slurper qw/read_binary write_text/;
use JSON qw//;

my $FILENAME_EXE_X64 = 'binaries/Dominions596k.exe';
my $FILENAME_EPITHETS_OUT = 'src/lib/epithets.json';

my $EPITHET_LENGTH = 0x20;

my $blob = read_binary( $FILENAME_EXE_X64 );

# Find epithets array offset

my $first_epithet_bytes = pack('H*', '200f444201000000120004000000000000000000340c0c000000000000000000' ); # maybe first 4 bytes (name offset) varies?
my $EPITHETS_OFFSET = index $blob, $first_epithet_bytes;
die 'first epithet not found' if $EPITHETS_OFFSET == -1;

# Find strings offset ( image base 0x1400000000 + image base offset (0x1600 for 5.96k) )

my $STRINGS_OFFSET = 0; 
my $ix = -1;
while(1) {
	$ix = index( $blob, '! Who Stole the Fire', $ix + 1 );
	last if $ix == -1;
	$STRINGS_OFFSET = 0x142440f20 - $ix;
}

# Read all epithets

my @epithets;
for ( my $epithet_i = 0; ; $epithet_i++ ) {
	my $epithet_bytes = substr( $blob, $EPITHETS_OFFSET + $epithet_i * $EPITHET_LENGTH, $EPITHET_LENGTH );
	#say map { sprintf( "%02x", $_) } unpack 'C*', $epithet_bytes; # print epithet byte string
	my ( $name_offset, @conditions_and_values ) = unpack 'Q<'.('s<'x12), $epithet_bytes;
	my $name = get_cstring( $blob, $name_offset - $STRINGS_OFFSET );
	last if $name eq 'end';

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
	say get_cstring( $blob, 0x135f5e8 - 0x1600 );

}

sub constraint_hash {
	my ( $con, $val ) = @_;

	if ( 1000 <= $con && $con <= 1007  && $val == 0 ) {
		# Magic path >= 0
		# Presumably mistaken condition. Affects:
		# - # of the Apes
		# - The Destroyer
		# - The Unborn
		# TODO: check disassembly to make sure this is ignored.
		return;
	}

	if ( $con ==    0 ) { return; }

	# Unique: No other epithets of this category can be chosen
	if ( $con ==    4 ) { return {'type' => 'unique', value => $val} }

	# Nation
	if ( $con ==    3 ) { return {'type' => 'nation', value => $val } }

	# mnr / chassis
	if ( $con ==   18 ) { return {'type' => 'chassis', value => $val } }

	# Gender
	if ( $con ==    2 ) {
		if ( $val == 0 ) {
			return {'type' => 'gender', value => 'female' }
		} elsif ( $val == 1 ) {
			return {'type' => 'gender', value => 'male' }
		} else {
			die "valid gender unhandled";
		}
	}
	if ( $con ==   19 ) {
		if ( $val == 0 ) {
			return {'type' => 'team leader gender', value => 'female' }
		} elsif ( $val == 1 ) {
			return {'type' => 'team leader gender', value => 'male' }
		} else {
			die "valid gender but unhandled";
		}
	}

	# Boolean
	if ( $con ==   11 ) { return {'type' => 'boolean', 'field' => 'undead',    'value' => $val } }
	if ( $con ==   12 ) { return {'type' => 'boolean', 'field' => 'demon',     'value' => $val } }
	if ( $con ==   14 ) { return {'type' => 'boolean', 'field' => 'immortal',  'value' => $val } }
	if ( $con ==   15 ) { return {'type' => 'boolean', 'field' => 'immobile',  'value' => $val } }
	if ( $con ==   16 ) { return {'type' => 'boolean', 'field' => 'inanimate', 'value' => $val } }
	if ( $con ==   17 ) { return {'type' => 'boolean', 'field' => 'disciple',  'value' => $val } }

	# Misc.
	if ( $con ==    1 ) { return {'type' => 'misc minimum', field => 'dominion strength', 'value' => $val } }
	if ( $con ==    5 ) { return {'type' => 'misc minimum', field => 'fear',              'value' => $val } }
	if ( $con ==    6 ) { return {'type' => 'misc minimum', field => 'awe',               'value' => $val } }
	if ( $con ==    7 ) { return {'type' => 'misc minimum', field => 'strength',          'value' => $val } }
	if ( $con ==   20 ) { return {'type' => 'misc minimum', field => 'eyes',              'value' => $val+2 } }
	if ( $con ==   21 ) {
		# TODO
		warn "unknown condition: $con=$val";
		return {'type' => 'unknown'};
	}

	# Minimum magic path
	if ( $con == 1000 ) { return {'type' => 'magic path', 'field' => 'F', 'value' => $val } }
	if ( $con == 1001 ) { return {'type' => 'magic path', 'field' => 'A', 'value' => $val } }
	if ( $con == 1002 ) { return {'type' => 'magic path', 'field' => 'W', 'value' => $val } }
	if ( $con == 1003 ) { return {'type' => 'magic path', 'field' => 'E', 'value' => $val } }
	if ( $con == 1004 ) { return {'type' => 'magic path', 'field' => 'S', 'value' => $val } }
	if ( $con == 1005 ) { return {'type' => 'magic path', 'field' => 'D', 'value' => $val } }
	if ( $con == 1006 ) { return {'type' => 'magic path', 'field' => 'N', 'value' => $val } }
	if ( $con == 1007 ) { return {'type' => 'magic path', 'field' => 'G', 'value' => $val } }
	if ( $con == 1008 ) { return {'type' => 'magic path', 'field' => 'B', 'value' => $val } }
	if ( $con == 1051 ) { return {'type' => 'magic paths', field => 'FAWE',      'value' => $val } } 
	if ( $con == 1052 ) { return {'type' => 'magic paths', field => 'SDNB',      'value' => $val } }# TODO check how this changed with Glamor
	if ( $con == 1053 ) { return {'type' => 'magic paths', field => 'FAWESDNB',  'value' => $val } }# TODO check how this changed with Glamor


	# Max scale
	if ( $con == 2000 ) { return { 'type' => 'scale', 'field' => 'Turmoil',      value => $val } }
	if ( $con == 2001 ) { return { 'type' => 'scale', 'field' => 'Sloth',        value => $val } }
	if ( $con == 2002 ) { return { 'type' => 'scale', 'field' => 'Cold',         value => $val } }
	if ( $con == 2003 ) { return { 'type' => 'scale', 'field' => 'Death',        value => $val } }
	if ( $con == 2004 ) { return { 'type' => 'scale', 'field' => 'Misfortune',   value => $val } }
	if ( $con == 2005 ) { return { 'type' => 'scale', 'field' => 'Drain',        value => $val } }

	# Min scale
	if ( $con == 2100 ) { return { 'type' => 'scale', 'field' => 'Order',        value => $val } }
	if ( $con == 2101 ) { return { 'type' => 'scale', 'field' => 'Productivity', value => $val } }
	if ( $con == 2102 ) { return { 'type' => 'scale', 'field' => 'Heat',         value => $val } }
	if ( $con == 2103 ) { return { 'type' => 'scale', 'field' => 'Growth',       value => $val } }
	if ( $con == 2104 ) { return { 'type' => 'scale', 'field' => 'Luck',         value => $val } }
	if ( $con == 2105 ) { return { 'type' => 'scale', 'field' => 'Magic',        value => $val } }

	warn "unhandled condition: $con=$val";
}

sub get_titles {
	my ( $blob, $start, $num_titles ) = @_;
	my @title_offsets = unpack 'Q<'x5, substr($blob, $start - 0x1600, 8*$num_titles  );
	my @titles = map { get_cstring( $blob, $_ - 0x1600 - 0x140000000 ) } @title_offsets;
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
