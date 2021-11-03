<script>
	import Constraint from './Constraint.svelte';
	export let id;
	export let string;
	export let constraints;
</script>

	<h2 class="epithet_string">{string}</h2>
	<span class="constraints">
	{#each constraints as constraint}
		<Constraint epithet_id={id} {...constraint}/>
	{/each}
	</span>

<style>
	h2.epithet_string {
		grid-column:1;
		margin:0 20px 0 0;
		padding:0;
		font-size:20px;
		font-weight:bold;
		/*
		border-top-left-radius:12px;
		border-bottom-left-radius:12px;
		*/
	}
	.constraints {
		grid-column:2;
		/*
		border-top-right-radius:12px;
		border-bottom-right-radius:12px;
		*/
	}
	h2.epithet_string, .constraints {
		text-align:left;
		line-height:18px;
		/*background-color: #2F195F;*/
	}
</style>
