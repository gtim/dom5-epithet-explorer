<script>

	import AutoComplete from "simple-svelte-autocomplete";

	import Epithet from './Epithet.svelte';
	import * as eps from './epithets.json';

	import { flip } from "svelte/animate";
	import { fade , crossfade } from "svelte/transition";

	const [send, receive] = crossfade({ duration: 200, fallback: fade });

	// Sort epithets

	eps.epithets.sort( function(epithet_a,epithet_b) {
		var a_normalized_string = epithet_a.string.replace( /[!#$ ']/g, '' );
		var b_normalized_string = epithet_b.string.replace( /[!#$ ']/g, '' );
		return a_normalized_string.localeCompare( b_normalized_string );
	} );
	
	// Selected-Epithets list handling

	let selectedEpithet;
	let selectedEpithets = [eps.epithets[361], eps.epithets[200], eps.epithets[8], eps.epithets[111] ];
	$: if ( selectedEpithet ) {
		if ( ! epithetIsAlreadySelected( selectedEpithet ) ) {
			selectedEpithets.push( selectedEpithet );
			selectedEpithets = selectedEpithets;
		}
		selectedEpithet = '';
	}

	function epithetIsAlreadySelected( epithet ) {
		for ( var i = 0; i < selectedEpithets.length; i++ ) {
			if ( selectedEpithets[i].id == epithet.id ) {
				return true;
			}
		}
		return false;
	}

	function unselectEpithetByIndex( i ) {
		selectedEpithets.splice( i, 1 );
		selectedEpithets = selectedEpithets;
	}

	function unselectEpithetById( epithet_id ) {
		for ( var i = 0; i < selectedEpithets.length; i++ ) {
			if ( selectedEpithets[i].id == epithet_id ) {
				unselectEpithetByIndex(i);
			}
		}
	}

</script>

<main>
	<h1>Epithet Explorer for Dominions 5</h1>

	<div>
		<AutoComplete 
			items={eps.epithets} bind:selectedItem={selectedEpithet}
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

</main>

<style>
	main {
		padding: 1em;
		max-width: 480px;
		margin: 0 auto;
		text-align:center;
	}
	h1 {
		text-align:center;
		font-size:32px;
		margin:0 0 40px 0;
	}
	div.epithets {
		display:table;
		margin:40px auto 0 auto;
		border-collapse:separate;
	}
	div.epithet {
		display:table-row;
	}
	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
</style>
