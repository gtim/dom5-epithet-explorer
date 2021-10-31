<script>

	import AutoComplete from "simple-svelte-autocomplete";
	import * as eps from './epithets.json';

	let selectedEpithet;
	let selectedEpithets = [eps.epithets[0], eps.epithets[200]];

	$: if ( selectedEpithet ) {
		selectedEpithets.push( selectedEpithet );
		selectedEpithets = selectedEpithets;
	}

</script>

<main>
	<AutoComplete 
		items={eps.epithets} bind:selectedItem={selectedEpithet}
		labelFieldName="string"
		valueFieldName="id"
	/>
	<div style="display:flex;justify-content:center;">
		{#each selectedEpithets as ep}
			<div style="flex-direction:row;">{ep.string}</div>
		{/each}
		<div>
		</div>
	</div>

</main>

<style>
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
