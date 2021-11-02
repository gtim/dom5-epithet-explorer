# Generate a map of unit/chassis ID to unit name for pretenders.
#
# Parses BaseU.csv and filters on dominion strength. This includes some 
# false positives but we don't mind. Assumes working directory is ./scripts.
#
# Thank you Larz for generating BaseU.csv
# https://github.com/larzm42/dom5inspector/blob/gh-pages/gamedata/BaseU.csv


use 5.26.0;
use warnings;

use Text::CSV qw/csv/;
use File::Slurper qw/write_text/;
use JSON;

# Parse BaseU.csv

my $units = csv(
	in => 'BaseU.csv',
	sep_char => "\t",
	headers => "auto"
);

# Filter out mnr+name of pretenders (and false positives) 

my %pretenders =
	map { $_->{id} => $_->{name} }
	grep { $_->{startdom} }
	@$units;

# Write JSON
	
my $json = JSON->new->canonical->pretty;
my $pretenders_json = $json->encode( { pretenders_by_id => \%pretenders } );
write_text( '../src/pretenders.json', $pretenders_json );
