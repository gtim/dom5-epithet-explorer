<script>

	import { createEventDispatcher } from 'svelte';
	import Constraint from './Constraint.svelte';


	export let id;
	export let string;
	export let constraints;
	export let displayRemoveLink = false;

	const dispatch = createEventDispatcher();

	if ( constraints.length == 0 ) {
		constraints.push( { type: "no constraints" } );
	}

	// Sort constraints

	constraints.sort( function(constraint_a,constraint_b) {
		var a_order = constraint_order(constraint_a);
		var b_order = constraint_order(constraint_b);
		if ( a_order > b_order ) {
			return 1;
		} else if ( a_order < b_order ) {
			return -1;
		} else {
			return 0;
		}
	} );
	function constraint_order( c ) {
		var mpath_order = {'F':1,'A':2,'W':3,'E':4,'S':5,'D':6,'N':7,'B':8};
		if ( c.type == "misc minimum" && c.field == "dominion strength" ) {
			return 100;
		} else if ( c.type == "magic paths" ) {
			return 200;
		} else if ( c.type == "magic path" ) {
			return 300 - c.value;
		} else if ( c.type == "scale" ) {
			return 400 - c.value;
		} else if ( c.type == "unique" ) {
			return 1000000;
		} else {
			return 10000;
		}
	}
</script>

<div class="epithet_wrapper">
	<h2 class="epithet_string">{string}</h2>
	<span class="constraints">
	{#each constraints as constraint}
		<Constraint epithet_id={id} {...constraint}/>
	{/each}
	</span>
</div>
{#if displayRemoveLink}
	<a class="removelink" href="#" on:click={()=>dispatch("remove")}>&#xd7;</a>
{/if}

<style>
	h2.epithet_string {
		padding:0 20px 0 0;
		font-size:20px;
		font-weight:bold;
	}
	.constraints {
	}
	.removelink {
		padding:0 0 0 20px;
	}
	h2.epithet_string, .constraints, .removelink {
		display:table-cell;
		text-align:left;
		line-height:18px;
		/*background-color: #2F195F;*/
		padding-bottom:20px;
	}
	div.epithet_wrapper {
		margin:0;
		padding:0;
		display:contents;
	}
	@media (max-width: 480px) {
		div.epithet_wrapper {
			display:table-cell;
		}
		h2.epithet_string {
			display:block;
			margin:0;
			padding:4px;
		}
		span.constraints {
			display:block;
			margin:0 0 12px 0;
			padding:4px;
		}
		a.removelink {
			padding:4px;
			vertical-align:middle;
		}
	}
</style>
