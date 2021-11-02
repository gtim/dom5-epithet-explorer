<script>
	export let type;
	export let field;
	export let value;
</script>

<div class="constraint">
	{#if type == "magic path"}
		<img src="/img/Path_{field}.png" style="height:24px;"> {value}
	{:else if type == "scale"}
		<img src="/img/Scale_{field.toLowerCase()}.png" style="height:32px;"/> {value}
	{:else if type == "misc minimum"}
		{field} &GreaterEqual; {value}
	{:else if type == "boolean"}
		{value ? "" : "not"} {field}
	{:else}
		[ {type} : {field} : {value} ]
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
