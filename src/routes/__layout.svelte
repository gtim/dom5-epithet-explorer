<script>
	import '../app.css';
</script>

<main>
	
	<div class="content">

		<ul class="nav">
			<li class="active"><a href="/">Epithet Search</a></li><!--
			--><li><a href="/requirement">Requirements</a></li>
		</ul>

		<slot/>

	</div>

	<p class="notes">
		hi! thanks for checking out my dom5 <a href="/">epithet explorer</a>!
		all feedback is welcome on <a rel="external" href="https://github.com/gtim/dom5-epithet-explorer">github</a> and discord&nbsp;(@timotej).
		you can also search epithets by 
			magic paths (<a href="/fire">F</a><a href="/air">A</a><a href="/water">W</a><a href="/earth">E</a><a href="/astral">S</a><a href="/death">D</a><a href="/nature">N</a><a href="/blood">B</a>),
			scales (<a href="/order">O</a><a href="/productivity">P</a><a href="/heat">H</a><a href="/growth">G</a><a href="/luck">L</a><a href="/magic">M</a>
				<a href="/turmoil">T</a><a href="/sloth">S</a><a href="/cold">C</a><a href="/death-scale">D</a><a href="/misfortune">M</a><a href="/drain">D</a>),
			<a href="/male">male</a>/<a href="/female">female</a>,
			<a href="/undead">undead</a>,
			<a href="/demon">demon</a>,
			<a href="/immobile">immobile</a> and
			<a href="/inanimate">inanimate</a>.
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
		transition: .3s color;
		margin:0;
		padding:0 20px;
	}
	ul.nav a:hover {
		color: #FAA6FF;
	}
	ul.nav li.active a {
		color: #fcfcfc;
		cursor: default;
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
