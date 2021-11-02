<script>

	import * as nations from './nations.json';
	import * as pretenders from './pretenders.json';

	export let type;
	export let field;
	export let value;
</script>

<div class="constraint">
	{#if type == "magic path"}
		<img src="/img/Path_{field}.png" style="height:24px;"> &GreaterEqual; {value}
	{:else if type == "magic paths"}
		{#each field.split('') as path}
			<img src="/img/Path_{path}.png" style="height:24px;"> 
		{/each}
		&GreaterEqual; {value}
	{:else if type == "scale"}
		<img src="/img/Scale_{field.toLowerCase()}.png" style="height:32px;"/> &GreaterEqual; {value}
	{:else if type == "misc minimum"}
		{field} &GreaterEqual; {value}
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
	{:else}
		[ invalid constraint "{type}:{field}:{value}", please report this bug! }
	{/if}
</div>

<style>
	div.constraint {
		position:relative;
		box-sizing:border-box;
		width:100%;
		margin:0;
		padding:8px;
		font-size:24px;
		line-height:24px;
		/*background-color:#fcc;*/
	}
</style>
