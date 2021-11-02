<script>
	import Constraint from './Constraint.svelte';
	export let id;
	export let string;
	export let constraints;
</script>

<div class="epithet_card">
	<h2>{string}</h2>
	{#each constraints as constraint}
		<Constraint epithet_id={id} {...constraint}/>
	{/each}
</div>

<style>
	div.epithet_card {
		display:inline-block;
		vertical-align:top;
		padding:14px 14px 4px 14px;
		margin:0 12px 24px 12px;
		min-height:220px;
		background-color: #2F195F;
		border-radius:16px;
		font-size:16px;
		line-height:16px;
	}
	div.epithet_card h2 {
		font-size:20px;
		font-weight:bold;
		margin:0 0 24px 0;
	}
</style>
