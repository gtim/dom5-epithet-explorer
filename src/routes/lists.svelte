<script>
	import { site_section } from './_stores.js';
	site_section.set('lists');

	import ListNav from '$lib/ListNav.svelte';
</script>

<svelte:head>
	<title>Epithet Lists - Dominions 5</title>
</svelte:head>

<ListNav />

