<script>

	import AutoComplete from "simple-svelte-autocomplete";

	import Epithet from './Epithet.svelte';
	import * as eps from './epithets.json';

	import { flip } from "svelte/animate";
	import { fade , crossfade } from "svelte/transition";

	const [send, receive] = crossfade({ duration: 200, fallback: fade });

	// Sort epithets

	let epithets = eps.epithets;
	epithets.sort( function(epithet_a,epithet_b) {
		var a_normalized_string = epithet_a.string.replace( /[!#$ ']/g, '' );
		var b_normalized_string = epithet_b.string.replace( /[!#$ ']/g, '' );
		return a_normalized_string.localeCompare( b_normalized_string );
	} );

	// Collapse epithets with the same name -- assumes sorted list

	epithets = collapse_samename_epithets( epithets );
	
	// Selected-Epithets list handling

	let selectedEpithet;
	let selectedEpithets = [];
	$: if ( selectedEpithet ) {
		if ( ! epithetIsAlreadySelected( selectedEpithet ) ) {
			selectedEpithets.push( selectedEpithet );
			selectedEpithets = selectedEpithets;
			if (typeof ga === 'function') {
				ga('send', 'event', 'Epithet', 'Select', selectedEpithet.string, selectedEpithets.length );
			}
		}
		selectedEpithet = '';
	}

	function epithetIsAlreadySelected( epithet ) {
		for ( let i = 0; i < selectedEpithets.length; i++ ) {
			if ( selectedEpithets[i].id == epithet.id ) {
				return true;
			}
		}
		return false;
	}

	function unselectEpithetByIndex( i ) {
		let unselectedEpithet = selectedEpithets.splice( i, 1 );
		selectedEpithets = selectedEpithets;
		if (typeof ga === 'function') {
			ga('send', 'event', 'Epithet', 'Unselect', unselectedEpithet[0].string, selectedEpithets.length );
		}
	}

	function unselectEpithetById( epithet_id ) {
		for ( var i = 0; i < selectedEpithets.length; i++ ) {
			if ( selectedEpithets[i].id == epithet_id ) {
				unselectEpithetByIndex(i);
			}
		}
	}


	// Collapse epithets with the same name -- assumes sorted list

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

</script>

<main>
	<div class="content">

		<h1>Epithet Explorer</h1>

		<div>
			<AutoComplete 
				items={epithets} bind:selectedItem={selectedEpithet}
				labelFieldName="string"
				valueFieldName="id"
				className="input_container"
				inputClassName="input_field"
				dropdownClassName="input_dropdown"
				placeholder="start typing a Pretender's epithet.."
			/>
		</div>

		<div class="epithets">
			{#each selectedEpithets as epithet, i (epithet.id)}
				<div class="epithet"
				  animate:flip="{{duration:500}}"
				  in:receive="{{key:epithet.id}}"
				  out:send="{{key:epithet.id}}" >
					<Epithet {...epithet}
					  on:remove={()=>unselectEpithetByIndex(i)} />
				</div>
			{/each}
		</div>

	</div>

	<p class="notes">
		hi! thanks for checking out my dom5 epithet explorer!
		all feedback is welcome on <a href="https://github.com/gtim/dom5-epithet-explorer">github</a> and discord&nbsp;(@timotej). /tim
	</p>
	<!--
		this is a pretender title/epithet explorer I made for dominions 5, thanks for checking it out!
		you can enter your opposing pretenders' epithets to get an idea of their capabilities.
		ideas, praise and bug reports are welcome on <a href="https://github.com/gtim/dom5-epithet-explorer">github</a> and discord&nbsp;(@timotej).
		epithets are current as of dominions 5.54.
		/Tim
	-->

</main>

<style>
	main {
		display:flex;
		flex-direction:column;
		justify-content:space-between;
		max-width: 480px;
		min-height:100vh;
		margin: 0 auto;
		text-align:center;
	}
	h1 {
		text-align:center;
		font-size:32px;
		margin:16px 0 40px 0;
	}
	div.epithets {
		display:table;
		margin:40px auto 0 auto;
		border-collapse:separate;
	}
	div.epithet {
		display:table-row;
	}
	p.notes {
		margin:8px auto 16px auto;
		padding:0;
		font-size:12px;
		text-align:left;
		/*max-width:480px;*/
	}
	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
</style>
