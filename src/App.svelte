<script>

	import AutoComplete from "simple-svelte-autocomplete";
	import * as eps from './epithets.json';

	let selectedEpithet;
	let selectedEpithets = [eps.epithets[0], eps.epithets[200]];

	$: if ( selectedEpithet ) {
		selectedEpithets.push( selectedEpithet );
		selectedEpithets = selectedEpithets;
		selectedEpithet = '';
	}

</script>

<main>
	<AutoComplete 
		items={eps.epithets} bind:selectedItem={selectedEpithet}
		labelFieldName="string"
		valueFieldName="id"
	/>

	<div class="epithet_cards">
		{#each selectedEpithets as ep}
			<div class="epithet_card">{ep.string}</div>
		{/each}
	</div>

</main>

<style>
	div.epithet_cards {
		display:flex;
		justify-content:center;
	}
	div.epithet_card {
		flex-direction:row;
		border:1px solid black;
		padding:8px;
		margin:12px;
	}
	main {
		text-align: center;
		padding: 1em;
		max-width: 480px;
		margin: 0 auto;
	}

	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
</style>
