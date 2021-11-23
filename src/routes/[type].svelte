<script context="module">
	export async function load({ page, fetch, session, stuff }) {
		switch ( page.params.type ) {
			case 'fire':
				return { props: { cfilter: (c) => c.type === "magic path" && c.field === "F" } }; break;
			case 'air':
				return { props: { cfilter: (c) => c.type === "magic path" && c.field === "A" } }; break;
			case 'water':
				return { props: { cfilter: (c) => c.type === "magic path" && c.field === "W" } }; break;
			case 'earth':
				return { props: { cfilter: (c) => c.type === "magic path" && c.field === "E" } }; break;
			case 'astral':
				return { props: { cfilter: (c) => c.type === "magic path" && c.field === "S" } }; break;
			case 'death':
				return { props: { cfilter: (c) => c.type === "magic path" && c.field === "D" } }; break;
			case 'nature':
				return { props: { cfilter: (c) => c.type === "magic path" && c.field === "N" } }; break;
			case 'blood':
				return { props: { cfilter: (c) => c.type === "magic path" && c.field === "B" } }; break;
		}
	}
</script>

<script>
	export let cfilter;

	import EpithetList from '$lib/EpithetList.svelte';
	import { AllEpithets } from '$lib/AllEpithets.js';

	// Filter epithets for N constraints

	let filteredEpithets = $AllEpithets.filter( function (epithet) {
		for ( const constraint of epithet.constraints ) {
			if ( cfilter( constraint ) ) {
				epithet.sort = constraint.value;
				return true;
			}
		}
		return false;
	} ).sort( (ep_a,ep_b) => ep_b.sort - ep_a.sort );

</script>

<main>
	the cfilter is { cfilter }

	<EpithetList epithets={filteredEpithets} />

</main>

