<script>

	import AutoComplete from "simple-svelte-autocomplete";

	import Epithet from './Epithet.svelte';
	import * as eps from './epithets.json';

	// Sort epithets

	eps.epithets.sort( function(epithet_a,epithet_b) {
		var a_normalized_string = epithet_a.string.replace( /[!#$ ']/g, '' );
		var b_normalized_string = epithet_b.string.replace( /[!#$ ']/g, '' );
		return a_normalized_string.localeCompare( b_normalized_string );
	} );
	
	// Add epithet to list when selected

	let selectedEpithet;
	let selectedEpithets = [eps.epithets[361], eps.epithets[200], eps.epithets[8], eps.epithets[111] ];
	$: if ( selectedEpithet ) {
		selectedEpithets.push( selectedEpithet );
		selectedEpithets = selectedEpithets;
		selectedEpithet = '';
	}

	function unselectEpithetByIndex( i ) {
		selectedEpithets.splice( i, 1 );
		selectedEpithets = selectedEpithets;
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

	<div class="epithet_cards">
		{#each selectedEpithets as epithet,i}
			<Epithet {...epithet}
			  on:remove={()=>unselectEpithetByIndex(i)} />
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
		margin:0px;
	}
	div.epithet_cards {
		display:inline-grid;
		grid-template:auto auto;
		column-grap:0;
		row-gap:24px;
		/*border: solid #7353BA 1px;*/
		border-radius:12px;
	}
	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
</style>
