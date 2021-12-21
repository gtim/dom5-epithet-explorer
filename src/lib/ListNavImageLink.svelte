<script>
	export let href, src, title;

	import { page } from "$app/stores"
	$: isActive = ( $page.path === href )

</script>


<li class:active={isActive}>
	<a {href}>
		<span style="display:inline-block;vertical-align:middle;height:100%;"></span><!--
		--><img {src} {title} alt="{title}"/>
	</a>
</li>


<style>
	li {
		display: inline-block;
		margin:0;
		padding:0;
	}
	li a {
		white-space:nowrap;
		text-decoration: none;
		border:none;
		display: block;
		margin:0;
		padding:0 6px;
		min-width:34px;
		height:48px;
		border: solid 1px transparent;
	}
	a:hover {
		border: solid 1px #FAA6FF;
	}
	li.active a {
		color: #fcfcfc;
	}
	img {
		vertical-align:middle;
	}
</style>
