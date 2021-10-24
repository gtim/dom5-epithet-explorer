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

for my $epithet_i ( 0..10, 323 ) {
#for my $epithet_i ( 0..745 ) {
	my $epithet_bytes = substr( $blob, $EPITHETS_OFFSET + $epithet_i * $EPITHET_LENGTH, $EPITHET_LENGTH );
	my ( $name_offset, @rest ) = unpack 'Q'.('S'x12), $epithet_bytes;
	my $name = get_cstring( $blob, $name_offset - $IMAGEBASE_OFFSET - 0x140000000 );

	printf "%3d: %s (0x%x)\n", $epithet_i, $name, $name_offset;
	printf "     @rest\n\n";
}

sub get_cstring {
	my ( $blob, $start ) = @_;
	my $end = index( $blob, chr(0), $start );
	die "could not find end of c string" if $end == -1;
	die "suspiciously long epithet (".($end-$start).")" if $end - $start > 70;
	return substr( $blob, $start, $end-$start );
}
