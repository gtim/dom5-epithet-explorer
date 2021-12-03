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

			case 'undead':
			case 'demon':
			case 'immortal': // none at the time of coding
			case 'immobile':
			case 'inanimate':
			case 'disciple':
				return { props: {
					ctype: page.params.type,
					cfilter: (c) => c.type === "boolean" && c.field === page.params.type && c.value === 1,
				} };
				break;

			case 'death-scale':
				var scale = 'death';
			case 'order':
			case 'turmoil':
			case 'productivity':
			case 'sloth':
			case 'heat':
			case 'cold':
			case 'growth':
			case 'luck':
			case 'misfortune':
			case 'magic':
			case 'drain':
				scale = typeof scale !== 'undefined' ? scale : page.params.type;
				return { props: {
					ctype: scale + '-scale',
					cfilter: (c) => c.type === "scale" && c.field.toLowerCase() === scale
				} }; break;

			case 'chassis':
				return { props: {
					ctype: page.params.type,
					cfilter: (c) => c.type === "chassis",
					pretender_phrase: "These are the epithets unique to specific pretender chassis."
				} }; break;
			case 'nation':
				return { props: {
					ctype: page.params.type,
					cfilter: (c) => c.type === "nation",
					pretender_phrase: "These are the epithets unique to specific nations."
				} }; break;

			case 'special':
				return { props: {
					ctype: page.params.type,
					cfilter: (c) => (
						c.type === "misc minimum" && ( c.field === "eyes" || c.field === "fear" || c.field === "awe" || c.field === "strength" )
						|| c.type === "default"
					),
					pretender_phrase: "These are the epithets requiring special properties not in the other lists."
				} }; break;
		}
	}
</script>

<script>
	export let ctype;
	export let cfilter;
	export let pretender_phrase = "";

	import EpithetList from '$lib/EpithetList.svelte';
	import ListNav from '$lib/ListNav.svelte';
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

	let ctypeCapitalisedFirst;
	$: ctypeCapitalisedFirst = ctype.charAt(0).toUpperCase() + ctype.slice(1);

</script>

	<svelte:head>
		<title>{ctypeCapitalisedFirst} Pretender Epithets in Dominions 5</title>
	</svelte:head>

	<ListNav />

	<p>
	{#if pretender_phrase}
		{pretender_phrase}
	{:else}
		{#if filteredEpithets.length == 1}
			This is the only epithet unique to {ctype} pretenders.
		{:else}
			These are the {filteredEpithets.length} epithets unique to {ctype} pretenders.
		{/if}
	{/if}
	{#if ctype == "order-scale"}
		The poetry and song Order-65535 bug is on my to-fix list.
	{/if}
	</p>

	<EpithetList epithets={filteredEpithets} />

