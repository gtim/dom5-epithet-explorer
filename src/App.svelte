<script>

	import AutoComplete from "simple-svelte-autocomplete";
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
				<ul>
				{#each ep.constraints as constraint}
					<li>{constraint.field}: {constraint.value}</li>
				{/each}
				</ul>
			</div>
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
