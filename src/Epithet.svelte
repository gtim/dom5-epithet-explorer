<script>

	import { createEventDispatcher } from 'svelte';
	import Constraint from './Constraint.svelte';


	export let id;
	export let string;
	export let constraints;

	const dispatch = createEventDispatcher();

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

	<h2 class="epithet_string">{string}</h2>
	<span class="constraints">
	{#each constraints as constraint}
		<Constraint epithet_id={id} {...constraint}/>
	{/each}
	</span>
	<a class="removelink" href="#" on:click={()=>dispatch("remove")}>&#xd7;</a>

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
</style>
