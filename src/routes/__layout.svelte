<script>
	import '../app.css';
</script>

<main>
	
	<div class="content">

		<h1>Epithet Explorer</h1>

		<slot/>

	</div>

	<p class="notes">
		hi! thanks for checking out my dom5 epithet explorer!
		all feedback is welcome on <a href="https://github.com/gtim/dom5-epithet-explorer">github</a> and discord&nbsp;(@timotej). /tim
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
