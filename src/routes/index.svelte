<script>

	import AutoComplete from "simple-svelte-autocomplete";

	import Epithet from '$lib/Epithet.svelte';
	import EpithetList from '$lib/EpithetList.svelte';
	import { AllEpithets } from '$lib/AllEpithets.js';

	// Selected-Epithets list handling

	let selectedEpithet;
	let selectedEpithets = [];
	$: if ( selectedEpithet ) {
		if ( ! epithetIsAlreadySelected( selectedEpithet ) ) {
			selectedEpithets.push( selectedEpithet );
			selectedEpithets = selectedEpithets;
			if (typeof gtag === 'function') {
				gtag("event", "add_to_cart", {
				  items: [ { item_name: selectedEpithet.string } ]
				});
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

</script>

	<div>
		<AutoComplete 
			items={$AllEpithets} bind:selectedItem={selectedEpithet}
			labelFieldName="string"
			valueFieldName="id"
			className="input_container"
			inputClassName="input_field"
			dropdownClassName="input_dropdown"
			placeholder="start typing a Pretender's epithet.."
		/>
	</div>

	<EpithetList bind:epithets={selectedEpithets} displayRemoveLink=true />

