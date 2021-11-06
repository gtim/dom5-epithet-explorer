<script>

	import * as nations from './nations.json';
	import * as pretenders from './pretenders.json';
	import { EpithetList } from './EpithetList.js';

	export let type;
	export let field = "";
	export let value;
	export let epithet_id;

	function unique_class_epithets( epithet_class ) {
		var class_epithets = new Array();
		$EpithetList.forEach( epithet => {
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

	function nation_ids_to_names( nation_ids ) {
		if ( ! Array.isArray( nation_ids ) ) {
			// Single nation
			return nations.nations_by_id[nation_ids];
		} else {
			// >1 nations (due to same-name epithet combining)
			let nation_names = nation_ids.map( id => nations.nations_by_id[id] );
			/*
			// TODO: combine same nation of different ages
			//   (by ordering reversed strings?)
			for ( let i = 0; i < nation_names.length; i++ ) {
				console.log( nation_names[i].substring(3) );
			}
			*/
			return nation_names.slice( 0, -1 ).join( ', ' ) + ' or ' + nation_names[ nation_names.length-1 ];
		}
	}
</script>

<div class="constraint">
	{#if type == "magic path"}
		<span class="image_widener"><img src="/img/Path_{field}.png" alt="{field} path"></span> &GreaterEqual; {value}
	{:else if type == "magic paths"}
		{#each field.split('') as path}
			<img src="/img/Path_{path}.png" style="height:18px;" alt="{field} path"> 
		{/each}
		&GreaterEqual; {value}
	{:else if type == "scale"}
		<span class="image_widener"><img src="/img/Scale_{field.toLowerCase()}.png" alt="{field} scale"/></span>
		{#if value == 3}
			= {value}
		{:else}
			&GreaterEqual; {value}
		{/if}
	{:else if type == "misc minimum"}
		{#if field == "dominion strength"}
			<span class="image_widener"><img src="/img/dominioncandle.png" alt="Dominion strength"/></span>
		{:else}
			{field}
		{/if}
		&GreaterEqual; {value}
	{:else if type == "boolean"}
		{value ? "" : "not"} {field}
	{:else if type == "nation"}
		{nation_ids_to_names(value)}
	{:else if type == "chassis"}
		{pretenders.pretenders_by_id[value]}
	{:else if type == "gender"}
		{value}
	{:else if type == "team leader gender"}
		disciple to {value} pretender
	{:else if type == "unique"}
		{#if unique_class_epithets(value).length == 1}
			lacks epithet <em>{unique_class_epithets(value)[0]}</em>
		{:else}
			lacks <span title="{unique_class_epithets(value).join(', ')}" class="unique_class_epithets_hover">these epithets</span>
		{/if}
	{:else if type == "no constraints"}
		no restrictions
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
