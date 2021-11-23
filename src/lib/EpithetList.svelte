<script>

	import Epithet from '$lib/Epithet.svelte';

	import { flip } from "svelte/animate";
	import { fade , crossfade } from "svelte/transition";
	const [send, receive] = crossfade({ duration: 200, fallback: fade });
	

	export let epithets;

	function unselectEpithetByIndex( i ) {
		let unselectedEpithet = epithets.splice( i, 1 );
		epithets = epithets;
		if (typeof gtag === 'function') {
			gtag("event", "remove_from_cart", {
			  items: [ { item_name: unselectedEpithet.string } ]
			});
		}
	}

	function unselectEpithetById( epithet_id ) {
		for ( var i = 0; i < epithets.length; i++ ) {
			if ( epithets[i].id == epithet_id ) {
				unselectEpithetByIndex(i);
			}
		}
	}

</script>

	<div class="epithets">
		{#each epithets as epithet, i (epithet.id)}
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
