<script>
	import '../app.css';
	import { site_section } from './_stores.js';
</script>

<main>
	
	<div class="content">

		<ul class="nav">
			<li class="{$site_section==='index'?'active':''}"><a href="/">Epithet Search</a></li><!--
			--><li class="{$site_section==='lists'?'active':''}"><a href="/lists">Epithet Lists</a></li>
		</ul>

		<slot/>

	</div>

	<p class="notes">
		hi! thanks for checking out my dom5 epithet explorer!
		all feedback is welcome on <a rel="external" href="https://github.com/gtim/dom5-epithet-explorer">github</a> and discord&nbsp;(@timotej).
		/tim
	</p>

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
		display:flex;
		flex-direction:column;
		justify-content:space-between;
		min-height:100vh;
		margin: 0 auto;
		text-align:center;
	}
	@media (max-width: 480px) {
		main {
			max-width: 480px;
		}
	}
	
	/* footer */

	p.notes {
		margin:8px auto 16px auto;
		padding:0;
		font-size:12px;
		text-align:left;
	}
</style>
