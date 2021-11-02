<script>

	import AutoComplete from "simple-svelte-autocomplete";

	import Constraint from './Constraint.svelte';
	import * as eps from './epithets.json';

	let selectedEpithet;
	let selectedEpithets = [eps.epithets[0], eps.epithets[200], eps.epithets[8] ];

	$: if ( selectedEpithet ) {
		selectedEpithets.push( selectedEpithet );
		selectedEpithets = selectedEpithets;
		selectedEpithet = '';
	}

</script>

<main>
	<div style="text-align:center;">
		<AutoComplete 
			items={eps.epithets} bind:selectedItem={selectedEpithet}
			labelFieldName="string"
			valueFieldName="id"
		/>
	</div>

	<div class="epithet_cards">
		{#each selectedEpithets as ep}
			<div class="epithet_card">
				<span class="string">{ep.string}</span>
				{#each ep.constraints as constraint}
					<Constraint {...constraint}/>
				{/each}
			</div>
		{/each}
		<div style="clear: both;"></div>
	</div>

</main>

<style>
	div.epithet_cards {
		/*background-color:#ccf;*/
		text-align:center;
	}
	div.epithet_card {
		display:inline-block;
		vertical-align:top;
		padding:8px;
		margin:12px;
		/*background-color:#cfc;*/
		min-height:120px;
	}
	div.epithet_card span.string {
		font-weight:bold;
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
