# Dom5 Epithet Explorer

A tool to explore pretender epithets/titles for the game Dominions 5. Deployed on **[epithets.illwiki.com](https://epithets.illwiki.com)**.

## Future improvements

Known bugs:
- "# of Poetry and Song" has order >= 65535

Minor improvements:
- handle titles (Prince / Lord / Emperor / etc)
- sprites for pretenders
- grey-out already picked epithets
- handle #/##/$ chars somehow 
- add explanatory title/hover texts to all constraints
- constraint-page: for sorcery/wizardry/all paths
- constraint-page: for fear/awe/strength/domstr
- constraint-page: for disciples
- constraint-page: for nations
- constraint-page: for constraint-less epithets
- constraint-page: for unreachable epithets
- constraint-page: "misc"/"special" for epithets not listed elsewhere, e.g. eyes and ruler of nothing
- constraint-page: icons instead of magic paths and scales abbreviations
- constraint-page: friendly intro text
- constraint-page: sort constraints s.t. relevant constraint comes first in each epithet
- constraint-page: add e.g. "not demon" epithets after demon constraint-page
- google search console thinks page is not mobile friendly because "clickable elements too close together" on constraint pages
- make top nav shrink with width s.t. it always fits on one line.

Major features that could be nice at some point:
- estimate dominion strength from number of epithets
- reverse-explorer: from a pretender design, estimate probability to get each epithet 

## Build instructions

- Clone this repository
- `npm install`
- If Dominions has been updated, make sure to update the binary, as well as `BaseU.csv` from the inspector.
- Extract epithets from the binary: `perl extract-epithets.pl`
- Get pretender names from unit IDs: `perl baseU_to_pretender.pl`
- Build: `npm run build`
- The web app can now be found in the build directory.
