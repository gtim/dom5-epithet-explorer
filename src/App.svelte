<script>

	import AutoComplete from "simple-svelte-autocomplete";

	import Epithet from './Epithet.svelte';
	import { EpithetList } from './EpithetList.js';

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
			if (typeof ga === 'function') {
				ga('send', 'event', 'Epithet', 'Select', selectedEpithet.string, selectedEpithets.length );
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
		if (typeof ga === 'function') {
			ga('send', 'event', 'Epithet', 'Unselect', unselectedEpithet[0].string, selectedEpithets.length );
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

<main>
	<div class="content">

		<h1>Epithet Explorer</h1>

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

	</div>

	<p class="notes">
		hi! thanks for checking out my dom5 epithet explorer!
		all feedback is welcome on <a href="https://github.com/gtim/dom5-epithet-explorer">github</a> and discord&nbsp;(@timotej). /tim
	</p>
	<!--
		this is a pretender title/epithet explorer I made for dominions 5, thanks for checking it out!
		you can enter your opposing pretenders' epithets to get an idea of their capabilities.
		ideas, praise and bug reports are welcome on <a href="https://github.com/gtim/dom5-epithet-explorer">github</a> and discord&nbsp;(@timotej).
		epithets are current as of dominions 5.54.
		/Tim
	-->

</main>

<style>
	main {
		display:flex;
		flex-direction:column;
		justify-content:space-between;
		max-width: 480px;
		min-height:100vh;
		margin: 0 auto;
		text-align:center;
	}
	h1 {
		text-align:center;
		font-size:32px;
		margin:16px 0 40px 0;
	}
	div.epithets {
		display:table;
		margin:40px auto 0 auto;
		border-collapse:separate;
	}
	div.epithet {
		display:table-row;
	}
	p.notes {
		margin:8px auto 16px auto;
		padding:0;
		font-size:12px;
		text-align:left;
		/*max-width:480px;*/
	}
	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
</style>
