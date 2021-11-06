import { readable } from 'svelte/store';
import * as eps from './epithets.json';

let epithets = eps.epithets;

/*
 * Sort epithets alphabetically
 */

epithets.sort( function(epithet_a,epithet_b) {
	return normalize_epithet_string( epithet_a.string ).localeCompare(
	       normalize_epithet_string( epithet_b.string )
	);
} );
function normalize_epithet_string( epithet_string ) {
	return epithet_string.replace( /[!#$ ']/g, '' );
}

/*
 * Collapse epithets with the same name -- assumes sorted list
 */

epithets = collapse_samename_epithets( epithets );

function collapse_samename_epithets( epithets ) {
	let collapsed_epithets = [];
	let samename_epithets = [];
	for ( let i = 0; i < epithets.length; i++ ) {
		if ( samename_epithets.length == 0 ) {
			// no ongoing samename list
			if ( i+1 < epithets.length && epithets[i].string === epithets[i+1].string ) {
				// first of a set: start the samename list
				samename_epithets.push( epithets[i] );
			} else {
				// not same as next: pass it through
				collapsed_epithets.push( epithets[i] );
			}
		} else {
			// ongoing samename list
			if ( epithets[i].string === samename_epithets[0].string ) {
				// in the same set: push to samename list
				samename_epithets.push( epithets[i] );
				if ( i+1 == epithets.length || epithets[i].string !== epithets[i+1].string ) {
					// set is finished: collapse the samename list
					let combined_epithet = combine_epithets( samename_epithets );
					if ( combined_epithet ) {
						collapsed_epithets.push( combined_epithet );
					} else {
						collapsed_epithets = collapsed_epithets.concat( samename_epithets );
					}
					samename_epithets = [];
				}
			} else {
				console.log( 'this should not happen, check your logic tim' );
			}
		}
	}
	return collapsed_epithets;
}

// Return a single combined epithet, or false if combining failed

function combine_epithets( epithets ) {
	let combined = {
		string: epithets[0].string,
		id: epithets[0].id,
		constraints: epithets[0].constraints
	};
	console.log( "Combining epithets named " + combined.string );
	for ( const epithet of epithets ) {
		// check string
		if ( epithet.string !== combined.string ) {
			return null;
			console.warn( "can't combine epithets with different names" );
		}
		// check id: use lowest
		if ( epithet.id < combined.id ) {
			combined.id = epithet.id;
		}
	}

	// make sure only one constraint changes, the others must be identical and of the same index

	let differing_constraint_i = -1;
	for ( let ep_i = 1; ep_i < epithets.length; ep_i++ ) {
		if ( epithets[0].constraints.length != epithets[ep_i].constraints.length ) {
			console.warn( "can't combine epithets: different number of constraints" );
			return false;
		}
		for ( let const_i = 0; const_i < epithets[0].constraints.length; const_i++ ) {
			let ca = epithets[0].constraints[const_i];
			let cb = epithets[ep_i].constraints[const_i];
			if ( constraints_are_identical( ca, cb ) ) {
				if ( differing_constraint_i != -1 && differing_constraint_i == const_i ) {
					console.warn( "can't combine epithets: expected different constraint but got identical" );
					return false;
				}
			} else if ( constraints_are_identical_except_maybe_value( ca, cb ) ) {
				if ( differing_constraint_i == -1 ) {
					differing_constraint_i = const_i;
				} else if ( differing_constraint_i != const_i ) {
					console.warn( "can't combine epithets: expected identical constraint but got different" );
					return false;
				}
			} else {
				console.warn( "can't combine epithets: too different constraints" );
				return false;
			}
		}
	}

	// Combine the list of constraints that differ only in value into a single constraint

	let values = epithets.map( epithet => epithet.constraints[differing_constraint_i].value );
	let ctype = epithets[0].constraints[differing_constraint_i].type;
	if ( ctype === "nation" ) {
		combined.constraints[differing_constraint_i].value = values;
	} else {
		console.warn( "no rule for combining constraints of type " + ctype );
		return false;
	}

	return combined;
}

function constraints_are_identical( ca, cb ) {
	return constraints_are_identical_except_maybe_value(ca,cb) && ca.value === cb.value;
}
function constraints_are_identical_except_maybe_value( ca, cb ) {
	return (
		ca.type === cb.type
		&& (
			ca.hasOwnProperty('field') && cb.hasOwnProperty('field') && ca.field === cb.field
			|| ! ca.hasOwnProperty('field') && ! cb.hasOwnProperty('field')
		)
	);
}


/*
 * Export the epithet list
 */

function createEpithetList( epithets ) {
	const { subscribe, set, update } = readable(epithets);
	return { subscribe };
}

export const EpithetList = createEpithetList( epithets );
