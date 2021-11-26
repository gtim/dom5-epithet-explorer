<script>
	import '../app.css';

	import { page } from '$app/stores';
	let site_section = 'lists';
	if ( $page.path === '/' ) {
		site_section = 'index';
	} else if ( $page.path === '/about' || $page.path === '/about/' ) {
		site_section = 'about';
	}
</script>

<main>
	
	<div class="content">

		<ul class="nav">
			<li class="{site_section==='index'?'active':''}"><a href="/">Epithet&nbsp;Search</a></li><!--
			--><li class="{site_section==='lists'?'active':''}"><a href="/lists/">Epithet&nbsp;Lists</a></li><!--
			--><li class="{site_section==='about'?'active':''}"><a href="/about/">About</a></li>
		</ul>

		<slot/>

	</div>

</main>

<footer>
</footer>

<style>
	
	/* Nav bar */

	ul.nav {
		list-style:none;
		text-align:center;
		padding:0;
		margin:20px 0 40px 0;
	}
	ul.nav li {
		display: inline-block;
		border-bottom: none;
		height: 50px;
		line-height: 50px;
		font-size: 1.4em;
		margin:0;
		padding:0;
		/*
		border-style:solid;
		border-color:#fcfcfc;
		border-width:0 0 1px 0;
		*/
	}
	ul.nav li a {
		text-decoration: none;
		color: #7353BA;
		display: block;
		margin:0;
		padding:0 20px;
	}
	ul.nav a:hover {
		color: #FAA6FF;
	}
	ul.nav li.active a {
		color: #fcfcfc;
	}
	ul.nav li.active {
		/*
		border-width:1px 1px 0 1px;
		height:51px;
		*/
	}

	/* main content */

	main {
		min-height:100vh;
		margin: 0 auto;
		text-align:center;
	}
	@media (max-width: 480px) {
		main {
			max-width: 480px;
		}
	}
</style>
