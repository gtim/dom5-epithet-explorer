<script context="module">
	export async function load({ page, fetch, session, stuff }) {
		if ( page.params.type === 'nature' ) {
			return { props: { ctype: page.params.type } };
		}
	}
</script>

<script>
	export let ctype;

	import EpithetList from '$lib/EpithetList.svelte';
	import { AllEpithets } from '$lib/AllEpithets.js';

	// Filter epithets for N constraints

	let filteredEpithets = $AllEpithets.filter( function (epithet) {
		for ( const constraint of epithet.constraints ) {
			if ( constraint.type === "magic path" && constraint.field === "N" ) {
				epithet.sort = constraint.value;
				return true;
			}
		}
		return false;
	} ).sort( (ep_a,ep_b) => ep_b.sort - ep_a.sort );

</script>

<main>
	the ctype is { ctype }

	<EpithetList epithets={filteredEpithets} />

</main>

