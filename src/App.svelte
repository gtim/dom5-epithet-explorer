<script>

	import AutoComplete from "simple-svelte-autocomplete";
	import * as eps from './epithets.json';

	let selectedEpithet;

</script>

<main>
	<AutoComplete 
	  items={eps.epithets} bind:selectedItem={selectedEpithet}
	  labelFieldName="string"
	  valueFieldName="id"
	/>
</main>

<style>
	main {
		text-align: center;
		padding: 1em;
		max-width: 240px;
		margin: 0 auto;
	}

	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
</style>
