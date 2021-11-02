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

my @epithets;

#for my $epithet_i ( 0..10, 323 ) {
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
	my $constr; # placeholder while converting sub to return hashref
	given ( $con ) {

		when (0) { return () }

		when (   1) { $constr = "Dom. Str.  >= $val"; }
		when (   2) {
			if ( $val == 0 ) {
				$constr = "Female";
			} elsif ( $val == 1 ) {
				$constr = "Male";
			} else { die "invalid val"; }
		}
		when (   3) { $constr = "Nation:    $val"; }
		when (   4) { $constr = "No other epithets in class $val"; }
		when (   5) { $constr = "Fear       >= $val"; }
		when (   6) { $constr = "Awe        >= $val"; }
		when (   7) { $constr = "Strength   >= $val"; }
		when (  11) { $constr = "Undead:    $val"; }
		when (  12) { $constr = "Demon:     $val"; }
		when (  14) { $constr = "Immortal:  $val"; }
		when (  15) { $constr = "Immobile:  $val"; }
		when (  16) { $constr = "Inanimate: $val"; }
		when (  17) {
			die "invalid val" unless $val == 1;
			$constr = "Disciple";
		}
		when (  18) { $constr = "Unit ID:   $val"; }
		when (  19) {
			if ( $val == 0 ) {
				$constr = "Disciple to a female pretender";
			} elsif ( $val == 1 ) {
				$constr = "Disciple to a male pretender";
			} else {
				die "invalid val";
			}
		}
		when (  20) { $constr = "Num. Eyes  >= ".($val+2); }

		# Minimum magic path
		when (1000) { return {'type' => 'magic path', 'field' => 'F', 'value' => $val } }
		when (1001) { return {'type' => 'magic path', 'field' => 'A', 'value' => $val } }
		when (1002) { return {'type' => 'magic path', 'field' => 'W', 'value' => $val } }
		when (1003) { return {'type' => 'magic path', 'field' => 'E', 'value' => $val } }
		when (1004) { return {'type' => 'magic path', 'field' => 'S', 'value' => $val } }
		when (1005) { return {'type' => 'magic path', 'field' => 'D', 'value' => $val } }
		when (1006) { return {'type' => 'magic path', 'field' => 'N', 'value' => $val } }
		when (1007) { return {'type' => 'magic path', 'field' => 'B', 'value' => $val } }

		when (1051) { $constr = "Each FAWE  >= $val"; }
		when (1052) { $constr = "Each SDNB  >= $val"; }
		when (1053) { $constr = "Each magic path >= $val"; }

		when (2000) { $constr = "Turmoil    >= $val"; }
		when (2001) { $constr = "Sloth      >= $val"; }
		when (2002) { $constr = "Cold       >= $val"; }
		when (2003) { $constr = "Death scale>= $val"; }
		when (2004) { $constr = "Misfortune >= $val"; }
		when (2005) { $constr = "Drain      >= $val"; }

		when (2100) { $constr = "Order      >= $val"; }
		when (2101) { $constr = "Production >= $val"; }
		when (2102) { $constr = "Heat       >= $val"; }
		when (2103) { $constr = "Growth     >= $val"; }
		when (2104) { $constr = "Luck       >= $val"; }
		when (2105) { $constr = "Magic      >= $val"; }

		default { $constr = sprintf "?? %d: %d", $con, $val }
	}
	return ();
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
