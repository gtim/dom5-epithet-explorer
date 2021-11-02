<script>

	import AutoComplete from "simple-svelte-autocomplete";

	import Epithet from './Epithet.svelte';
	import * as eps from './epithets.json';

	let selectedEpithet;
	let selectedEpithets = [eps.epithets[361], eps.epithets[200], eps.epithets[8], eps.epithets[111] ];

	$: if ( selectedEpithet ) {
		selectedEpithets.push( selectedEpithet );
		selectedEpithets = selectedEpithets;
		selectedEpithet = '';
	}

</script>

<main>
	<h1>Dominions 5 Epithet Explorer</h1>
	<div style="text-align:center;">
		<AutoComplete 
			items={eps.epithets} bind:selectedItem={selectedEpithet}
			labelFieldName="string"
			valueFieldName="id"
		/>
	</div>

	<div class="epithet_cards">
		{#each selectedEpithets as epithet}
			<Epithet {...epithet}/>
		{/each}
	</div>

</main>

<style>
	h1 {
		text-align:center;
		font-size:32px;
		margin-top:0px;
		margin-bottom:32px;
	}
	div.epithet_cards {
		margin: 20px 0 0 0;
		text-align:center;
	}
	main {
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
