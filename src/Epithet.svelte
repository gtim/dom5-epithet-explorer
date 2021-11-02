<script>
	import Constraint from './Constraint.svelte';
	export let id;
	export let string;
	export let constraints;
</script>

<div class="epithet_card">
	<span class="string">{string}</span>
	{#each constraints as constraint}
		<Constraint epithet_id={id} {...constraint}/>
	{/each}
</div>

<style>
	div.epithet_card {
		display:inline-block;
		vertical-align:top;
		padding:8px;
		margin:12px;
		/*background-color:#cfc;*/
		min-height:120px;
	}
	div.epithet_card span.string {
		font-size:24px;
		font-weight:bold;
	}
</style>
