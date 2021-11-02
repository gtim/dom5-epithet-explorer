<script>
	export let type;
	export let field;
	export let value;
</script>

<div class="constraint">
	[{field}:{value}]
</div>

<style>
	div.constraint {
		position:relative;
		box-sizing:border-box;
		width:100%;
		margin:0;
		padding:8px;
		background-color:#fcc;
	}
</style>
