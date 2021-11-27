<script>

	import * as nations from './nations.json';
	import * as pretenders from './pretenders.json';
	import { AllEpithets } from './AllEpithets.js';

	export let type;
	export let field = "";
	export let value;
	export let epithet_id;

	function unique_class_epithets( epithet_class ) {
		var class_epithets = new Array();
		$AllEpithets.forEach( epithet => {
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

		// Ascertain nation_ids is an array
		if ( ! Array.isArray( nation_ids ) ) {
			nation_ids = [ nation_ids ];
		}

		let nation_names = nation_ids.map( id => nations.nations_by_id[id] );

		nation_names = combine_ea_ma_la_nation_names( nation_names );

		if ( nation_names.length == 0 ) {
			console.warn( 'no nation names in name constraint: this should not happen' );
			return '[no nation name, please report this bug]';
		} else if ( nation_names.length == 1 ) {
			return nation_names[0];
		} else {
			return nation_names.slice( 0, -1 ).join( ', ' ) + ' or ' + nation_names[ nation_names.length-1 ];
		}
	}

	// Combine e.g. [ "EA Abysia", "MA Abysia", "EA C'Tis" ] to [ "EA/MA Abysia", "EA C'Tis" ]
	function combine_ea_ma_la_nation_names( nation_names ) {
		var combined_names = [];
		// Sort out nations beginning with EA/MA/LA
		var nation_ages = [];
		for ( let i = 0; i < nation_names.length; i++ ) {
			let age = nation_names[i].substring( 0, 2 );
			if ( age === 'EA' || age === 'MA' || age === 'LA' ) {
				let ageless_name = nation_names[i].substring( 3 );
				if ( ! ( ageless_name in nation_ages ) ) {
					nation_ages[ageless_name] = [];
				}
				nation_ages[ageless_name].push( age );
			} else {
				combined_names.push( nation_names[i] );
			}
		}
		// Combine EA/MA/LA nations
		for ( let ageless_name in nation_ages ) {
			let combined_name = nation_ages[ageless_name].join('/') + ' ' + ageless_name;
			combined_names.push( combined_name );
		}
		// Return
		return combined_names;
	}

	let title = "";
	let content = "";
	let images = [];

	if ( type == "magic path" ) {
		images.push( { src: "/img/Path_"+field+".png", alt: field + " path" } );
		content = ' &GreaterEqual; ' + value;
	} else if ( type == "magic paths" ) {
		for ( const path of field.split('') ) {
			images.push( { src: "/img/Path_"+path+".png", alt: path + " path" } );
		}
		content = ' &GreaterEqual; ' + value;
	} else if ( type == "scale" ) {
		images.push( { src: "/img/Scale_"+field.toLowerCase()+".png", alt: field + " scale" } );
		content = ( value == 3 ? ' = ' : ' &GreaterEqual; ' ) + value;
	} else if ( type == "misc minimum" ) {
		if ( field == "dominion strength" ) {
			images.push( { src: "/img/dominioncandle.png", alt: "Dominion strength" } );
			content = ' &GreaterEqual; ' + value;
		} else {
			content = field + ' &GreaterEqual; ' + value;
		}
	} else if ( type == "boolean" ) {
		content = ( value ? "" : "not " ) + field;
	} else if ( type == "nation" ) {
		content = nation_ids_to_names(value);
	} else if ( type == "chassis" ) {
		content = pretenders.pretenders_by_id[value];
	} else if ( type == "gender" ) {
		content = value;
	} else if ( type == "team leader gender" ) {
		content = 'disciple to ' + value + ' pretender';
	} else if ( type == "unique" ) {
		if ( unique_class_epithets(value).length == 1 ) {
			content = 'lacks epithet <em>' + unique_class_epithets(value)[0] + '</em>';
		} else {
			content = 'lacks <span title="' + unique_class_epithets(value).join(', ') + '" class="unique_class_epithets_hover">these epithets</span>';
		}
	} else if ( type == "no constraints" ) {
		content = 'no restrictions';
	} else if ( type == "default" ) {
		content = 'no epithet found after 10,000 random picks';
	} else {
		content = '[ invalid constraint "'+type+':'+field+':'+value+'", please report this bug! ]';
	}
</script>

<div class="constraint" {title}>
	{#if images.length == 1}
		<span class="image_widener"><img src="{images[0].src}" alt="{images[0].alt}"></span>
	{:else}
		{#each images as image}
			<img src="{image.src}" alt="{image.alt}" style="height:18px;">
		{/each}
	{/if}
	{@html content}
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
