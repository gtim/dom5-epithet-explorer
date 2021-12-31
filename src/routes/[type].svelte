<script context="module">

	function firstToUpperCase(str) {
		return str.charAt(0).toUpperCase() + str.slice(1);
	}

	export async function load({ page, fetch, session, stuff }) {
		if ( [ 'fire', 'air', 'water', 'earth', 'astral', 'death', 'nature', 'blood' ].includes( page.params.type ) ) {
			/* Magic Path */
			let path_abbrev = page.params.type === 'astral' ? 'S' : page.params.type.charAt(0).toUpperCase();
			return { props: {
				ctype: page.params.type,
				cfilter: (c) => c.type === "magic path" && c.field === path_abbrev,
				header_image: '/img/Path_' + path_abbrev + '.png',
				header_title: firstToUpperCase(page.params.type) + ' Pretender Epithets'
			} }; 
		} else if ( [ 'death-scale', 'order', 'turmoil', 'productivity', 'sloth', 'heat', 'cold', 'growth', 'luck', 'misfortune', 'magic', 'drain' ].includes( page.params.type ) ) {
			/* Scale */
			var scale = page.params.type === 'death-scale' ? 'death' : page.params.type;
			return { props: {
				ctype: scale + '-scale',
				cfilter: (c) => c.type === "scale" && c.field.toLowerCase() === scale,
				header_image: '/img/Scale_' + scale + '.png',
				header_title: firstToUpperCase(scale) + ' Pretender Epithets',
				header_text: scale === 'order' ? 'The poetry and song Order-65535 bug is on my to-fix list.' : ''
			} }; 
		} else {
			switch ( page.params.type ) {
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
	}
</script>

<script>
	export let ctype;
	export let cfilter;
	export let header_image;
	export let header_title;
	export let header_text;
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


	{#if header_title}
		<h1>
		{#if header_image}
			<img src="{header_image}" style="transform:scaleX(-1);"/>
		{/if}
		{header_title}
		{#if header_image}
			<img src="{header_image}"/>
		{/if}
		</h1>
		{#if header_text}
			<p>{header_text}</p>
		{/if}
	{:else}
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
		</p>
	{/if}

	<EpithetList epithets={filteredEpithets} />

	<ListNav />

<style>
	h1 {
		font-size: 1.6em;
		font-weight:normal;
		margin:40px auto 60px auto;
	}
	h1 img {
		height: 1.6em;
		vertical-align:middle;
		margin:0 24px;
	}
</style>
