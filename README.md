# Dom5 Epithet Explorer

A tool to explore pretender epithets/titles for the game Dominions 5. Deployed on **[epithets.illwiki.com](https://epithets.illwiki.com)**.

## Future improvements

Known bugs:
- "# of Poetry and Song" has order >= 65535

Minor improvements:
- handle titles (Prince / Lord / Emperor / etc)
- grey-out already picked epithets
- handle #/##/$ chars somehow 
- constraint-page: for sorcery/wizardry/all paths
- constraint-page: for domstr
- constraint-page: for constraint-less epithets
- constraint-page: for unreachable epithets
- constraint-page: icons instead of magic paths and scales abbreviations
- constraint-page: friendly intro text
- constraint-page: sort constraints s.t. relevant constraint comes first in each epithet
- constraint-page: add e.g. "not demon" epithets after demon constraint-page
- make top nav shrink with width s.t. it always fits on one line.

Major features that could be nice at some point:
- estimate dominion strength from number of epithets
- reverse-explorer: from a pretender design, estimate probability to get each epithet 

## Build instructions

    git clone https://github.com/gtim/dom5-epithet-explorer.git
    npm install
    npm run build

## Re-extract epithets when Dominions 5 updates

- `perl extract-epithets.pl` - extract epithets, set number of epithets manually
- update `BaseU.csv` from the dom5 inspector.
- `perl baseU_to_pretender.pl`
