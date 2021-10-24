#
# extracts epithets from game binary
#


use 5.26.0;
use warnings;

use File::Slurper qw/read_binary/;

my $FILENAME_EXE_X64 = 'Dominions554-64.exe';

my $IMAGEBASE_OFFSET = 0x2200;
my $EPITHETS_OFFSET = 0x13533b4-6 - $IMAGEBASE_OFFSET; 
my $EPITHET_LENGTH = 0x20;

my $blob = read_binary( $FILENAME_EXE_X64 );
say length $blob;

for my $epithet_i ( 0..747 ) {
	printf "%3d: ", $epithet_i;
	my $ep = substr( $blob, $EPITHETS_OFFSET + $epithet_i * $EPITHET_LENGTH, $EPITHET_LENGTH );
	say str_to_hexstr($ep);
}



sub str_to_hexstr {
	my $str = shift;
	my $hexstr = join '', map { sprintf "%02x", ord } split //, $str;
	my @chunks;
	push @chunks, substr( $hexstr, 0, 4, "" ) while length($hexstr);
	return join( ' ', @chunks );
}
