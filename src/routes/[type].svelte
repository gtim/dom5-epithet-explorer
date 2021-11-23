<script context="module">
	export async function load({ page, fetch, session, stuff }) {
		switch ( page.params.type ) {
			case 'fire':
				return { props: { ctype: page.params.type, cfilter: (c) => c.type === "magic path" && c.field === "F" } }; break;
			case 'air':
				return { props: { ctype: page.params.type, cfilter: (c) => c.type === "magic path" && c.field === "A" } }; break;
			case 'water':
				return { props: { ctype: page.params.type, cfilter: (c) => c.type === "magic path" && c.field === "W" } }; break;
			case 'earth':
				return { props: { ctype: page.params.type, cfilter: (c) => c.type === "magic path" && c.field === "E" } }; break;
			case 'astral':
				return { props: { ctype: page.params.type, cfilter: (c) => c.type === "magic path" && c.field === "S" } }; break;
			case 'death':
				return { props: { ctype: page.params.type, cfilter: (c) => c.type === "magic path" && c.field === "D" } }; break;
			case 'nature':
				return { props: { ctype: page.params.type, cfilter: (c) => c.type === "magic path" && c.field === "N" } }; break;
			case 'blood':
				return { props: { ctype: page.params.type, cfilter: (c) => c.type === "magic path" && c.field === "B" } }; break;

			case 'male':
				return { props: { ctype: page.params.type, cfilter: (c) => c.type === "gender" && c.value === "male" } }; break;
			case 'female':
				return { props: { ctype: page.params.type, cfilter: (c) => c.type === "gender" && c.value === "female" } }; break;
		}
	}
</script>

<script>
	export let ctype;
	export let cfilter;

	import EpithetList from '$lib/EpithetList.svelte';
	import { AllEpithets } from '$lib/AllEpithets.js';

	// Filter epithets for N constraints

	let filteredEpithets = [];
	$: filteredEpithets = $AllEpithets.filter( function (epithet) {
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
	<p>These are the {filteredEpithets.length} epithets unique to {ctype} pretenders. (<a href="/">go back to search</a>)</p>

	<EpithetList epithets={filteredEpithets} />

</main>

