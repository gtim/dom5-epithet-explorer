<script context="module">

	function firstToUpperCase(str) {
		return str.charAt(0).toUpperCase() + str.slice(1);
	}

	export async function load({ page, fetch, session, stuff }) {
		if ( [ 'fire', 'air', 'water', 'earth', 'astral', 'death', 'nature', 'blood' ].includes( page.params.type ) ) {
			/* Magic Path */
			let path_abbrev = page.params.type === 'astral' ? 'S' : page.params.type.charAt(0).toUpperCase();
			return { props: {
				cfilter: (c) => c.type === "magic path" && c.field === path_abbrev,
				header_image: '/img/Path_' + path_abbrev + '.png',
				header_title: firstToUpperCase(page.params.type) + ' Pretender Epithets'
			} }; 
		} else if ( [ 'death-scale', 'order', 'turmoil', 'productivity', 'sloth', 'heat', 'cold', 'growth', 'luck', 'misfortune', 'magic', 'drain' ].includes( page.params.type ) ) {
			/* Scale */
			var scale = page.params.type === 'death-scale' ? 'death' : page.params.type;
			return { props: {
				cfilter: (c) => c.type === "scale" && c.field.toLowerCase() === scale,
				header_image: '/img/Scale_' + scale + '.png',
				header_title: firstToUpperCase(scale) + ' Pretender Epithets',
				header_text: scale === 'order' ? 'The poetry and song Order-65535 bug is on my to-fix list.' : ''
			} }; 
		} else if ( page.params.type === 'chassis' ) {
			return { props: {
				cfilter: (c) => c.type === "chassis",
				header_image: '/img/pretender/2466.png',
				header_title: 'Chassis-specific Epithets'
			} }; 
		} else if ( page.params.type === 'nation' ) {
			return { props: {
				cfilter: (c) => c.type === "nation",
				header_title: 'Nation-specific Epithets'
			} }; 
		} else if ( page.params.type === 'male' ) {
			return { props: { 
				cfilter: (c) => c.type === "gender" && c.value === "male",
				header_title: 'Male Pretender Epithets'
			} };
		} else if ( page.params.type === 'female' ) {
			return { props: { 
				cfilter: (c) => c.type === "gender" && c.value === "female",
				header_title: 'Female Pretender Epithets'
			} };
		} else if ( page.params.type === 'disciple' ) {
			return { props: { 
				cfilter: (c) => c.type === "boolean" && c.field === 'disciple' && c.value === 1,
				header_title: 'Disciple Epithets'
			} };
		} else if ( [ 'undead', 'demon', 'immortal', 'immobile', 'inanimate' ].includes( page.params.type ) ) {
			// no immortal epithets at time of coding
			return { props: {
				cfilter: (c) => c.type === "boolean" && c.field === page.params.type && c.value === 1,
				header_title: firstToUpperCase(page.params.type) + ' Pretender Epithets'
			} };
		} else if ( page.params.type === 'special' ) {
			return { props: {
				cfilter: (c) => (
					c.type === "misc minimum" && ( c.field === "eyes" || c.field === "fear" || c.field === "awe" || c.field === "strength" )
					|| c.type === "default"
				),
				header_title: "Special Epithets"
			} };
		}
	}
</script>

<script>
	export let cfilter;
	export let header_image;
	export let header_title;
	export let header_text;

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

</script>

	<svelte:head>
		<title>{header_title} in Dominions 5</title>
	</svelte:head>


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
