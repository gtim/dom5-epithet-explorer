<script>

	import * as nations from './nations.json';
	import * as pretenders from './pretenders.json';
	import * as epithets from './epithets.json';

	export let type;
	export let field = "";
	export let value;
	export let epithet_id;

	function unique_class_epithets( epithet_class ) {
		var class_epithets = new Array();
		epithets.epithets.forEach( epithet => {
			epithet.constraints.forEach( constraint => {
				if ( constraint.type == "unique"
				     && constraint.value == epithet_class 
				     && epithet.id != epithet_id ) {
					class_epithets.push(epithet.string);
				}
			} );
		} );
		return class_epithets;
	}
</script>

<div class="constraint">
	{#if type == "magic path"}
		<span class="image_widener"><img src="/img/Path_{field}.png"></span> &GreaterEqual; {value}
	{:else if type == "magic paths"}
		{#each field.split('') as path}
			<img src="/img/Path_{path}.png" style="height:18px;"> 
		{/each}
		&GreaterEqual; {value}
	{:else if type == "scale"}
		<span class="image_widener"><img src="/img/Scale_{field.toLowerCase()}.png"/></span>
		{#if value == 3}
			= {value}
		{:else}
			&GreaterEqual; {value}
		{/if}
	{:else if type == "misc minimum"}
		{#if field == "dominion strength"}
			<span class="image_widener"><img src="/img/dominioncandle.png"/></span>
		{:else}
			{field}
		{/if}
		&GreaterEqual; {value}
	{:else if type == "boolean"}
		{value ? "" : "not"} {field}
	{:else if type == "nation"}
		{nations.nations_by_id[value]}
	{:else if type == "chassis"}
		{pretenders.pretenders_by_id[value]}
	{:else if type == "gender"}
		{value}
	{:else if type == "team leader gender"}
		disciple to {value} pretender
	{:else if type == "unique"}
		{#if unique_class_epithets(value).length == 1}
			lacks <span title="{unique_class_epithets(value)[0]}" class="unique_class_epithets_hover">this epithet</span>
		{:else}
			lacks <span title="{unique_class_epithets(value).join(', ')}" class="unique_class_epithets_hover">these epithets</span>
		{/if}
	{:else}
		[ invalid constraint "{type}:{field}:{value}", please report this bug! ]
	{/if}
</div>

<style>
	.constraint {
		position:relative;
		display:inline-block;
		margin: 0 20px;
		padding:0;
	}
	.constraint img {
		vertical-align:bottom;
	}
	span.image_widener {
		display:inline-block;
		width:26px; /* widest: Path_A.png */
		text-align:center;
	}
	span.image_widener img {
		height:18px;
	}
	span.unique_class_epithets_hover {
		text-decoration: underline #fcfcfc dashed;
	}
</style>
