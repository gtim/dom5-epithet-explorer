<script>
	import '../app.css';
</script>

<main>
	
	<div class="content">

		<h1>Epithet Explorer</h1>

		<slot/>

	</div>

	<p class="notes">
		hi! thanks for checking out my dom5 <a rel="external" href="/">epithet explorer</a>!
		all feedback is welcome on <a rel="external" href="https://github.com/gtim/dom5-epithet-explorer">github</a> and discord&nbsp;(@timotej).
		you can also search epithets by 
			magic paths (<a rel="external" href="/fire">F</a><a rel="external" href="/air">A</a><a rel="external" href="/water">W</a><a rel="external" href="/earth">E</a><a rel="external" href="/astral">S</a><a rel="external" href="/death">D</a><a rel="external" href="/nature">N</a><a rel="external" href="/blood">B</a>),
			scales (<a rel="external" href="/order">O</a><a rel="external" href="/productivity">P</a><a rel="external" href="/heat">H</a><a rel="external" href="/growth">G</a><a rel="external" href="/luck">L</a><a rel="external" href="/magic">M</a>
				<a rel="external" href="/turmoil">T</a><a rel="external" href="/sloth">S</a><a rel="external" href="/cold">C</a><a rel="external" href="/death-scale">D</a><a rel="external" href="/misfortune">M</a><a rel="external" href="/drain">D</a>),
			<a rel="external" href="/male">male</a>/<a rel="external" href="/female">female</a>,
			<a rel="external" href="/undead">undead</a>,
			<a rel="external" href="/demon">demon</a>,
			<a rel="external" href="/immobile">immobile</a> and
			<a rel="external" href="/inanimate">inanimate</a>.
		/tim
	</p>

</main>

<footer>
</footer>

<style>
	main {
		display:flex;
		flex-direction:column;
		justify-content:space-between;
		min-height:100vh;
		margin: 0 auto;
		text-align:center;
	}
	h1 {
		text-align:center;
		font-size:32px;
		margin:16px 0 40px 0;
	}
	p.notes {
		margin:8px auto 16px auto;
		padding:0;
		font-size:12px;
		text-align:left;
	}
	@media (max-width: 480px) {
		h1 {
			margin:8px 0 16px 0;
		}
		main {
			max-width: 480px;
		}
	}
</style>
