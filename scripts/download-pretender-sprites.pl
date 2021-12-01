#
# Download pretender sprites from dom inspector github.
#


use 5.26.0;
use warnings;
use experimental qw/switch/;

use File::Slurper qw/read_text/;
use JSON qw/decode_json/;

my $pretender_json_fn = '../src/lib/pretenders.json';
my $pretender_image_dir = '../static/img/pretender/';

die "pretender json file not found" unless -f $pretender_json_fn;
my $p = JSON->new->decode( read_text( $pretender_json_fn ) );

for my $id ( sort { 0+$a <=> 0+$b } keys $p->{pretenders_by_id}->%* ) {
	my $local_fn = $pretender_image_dir . $id . '.png';
	printf "pretender #%d (%s)\n", $id, $p->{pretenders_by_id}{$id};
	if ( -f $local_fn ) {
		say "  image exists: skipping";
		next;
	}
	my $github_url = sprintf( 'https://github.com/larzm42/dom5inspector/raw/gh-pages/images/sprites/%04d_1.png', 0+$id );
	my $wget_cmd = sprintf( 'wget --no-verbose %s -O %s', $github_url, $local_fn );
	say '$ ' . $wget_cmd;
	say `$wget_cmd`;
	say "wget failed: $!" if $?;
	sleep 1;
}
