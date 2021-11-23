<script>

	import AutoComplete from "simple-svelte-autocomplete";

	import Epithet from '$lib/Epithet.svelte';
	import { EpithetList } from '$lib/EpithetList.js';

	import { flip } from "svelte/animate";
	import { fade , crossfade } from "svelte/transition";

	const [send, receive] = crossfade({ duration: 200, fallback: fade });
	
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

	function unselectEpithetByIndex( i ) {
		let unselectedEpithet = selectedEpithets.splice( i, 1 );
		selectedEpithets = selectedEpithets;
		if (typeof gtag === 'function') {
			gtag("event", "remove_from_cart", {
			  items: [ { item_name: unselectedEpithet.string } ]
			});
		}
	}

	function unselectEpithetById( epithet_id ) {
		for ( var i = 0; i < selectedEpithets.length; i++ ) {
			if ( selectedEpithets[i].id == epithet_id ) {
				unselectEpithetByIndex(i);
			}
		}
	}


</script>

	<div>
		<AutoComplete 
			items={$EpithetList} bind:selectedItem={selectedEpithet}
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

<style>
	div.epithets {
		display:table;
		margin:40px auto 0 auto;
		border-collapse:separate;
	}
	div.epithet {
		display:table-row;
	}
	@media (max-width: 480px) {
		div.epithets {
			margin: 16px auto 0 auto;
		}
	}
</style>
