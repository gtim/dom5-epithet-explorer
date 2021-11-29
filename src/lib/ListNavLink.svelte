<script>
	export let href;

	import { page } from "$app/stores"
	$: isActive = ( $page.path === href )

</script>


<li class:active={isActive}>
	<a {href}>
		<slot />
	</a>
</li>


<style>
	li {
		display: inline-block;
		border-bottom: none;
		height: 20px;
		line-height: 48px;
		font-size: 18px;
		margin:0;
		padding:0;
	}
	li a {
		text-decoration: none;
		color: #7353BA;
		display: block;
		margin:0;
		padding:0 6px;
		min-width:34px;
	}
	a:hover {
		color: #FAA6FF;
	}
	li.active a {
		color: #fcfcfc;
	}
</style>
