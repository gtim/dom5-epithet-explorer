<script>
  import ListNavLink from '$lib/ListNavLink.svelte'
</script>

<ul class="listnav">
	<ListNavLink href="/fire/">F</ListNavLink>
	<ListNavLink href="/air/">A</ListNavLink>
	<ListNavLink href="/water/">W</ListNavLink>
	<ListNavLink href="/earth/">E</ListNavLink>
	<ListNavLink href="/astral/">S</ListNavLink>
	<ListNavLink href="/death/">D</ListNavLink>
	<ListNavLink href="/nature/">N</ListNavLink>
	<ListNavLink href="/blood/">B</ListNavLink>

	<ListNavLink href="/order/">O</ListNavLink>
	<ListNavLink href="/productivity/">P</ListNavLink>
	<ListNavLink href="/heat/">H</ListNavLink>
	<ListNavLink href="/growth/">G</ListNavLink>
	<ListNavLink href="/luck/">L</ListNavLink>
	<ListNavLink href="/magic/">M</ListNavLink>
	<ListNavLink href="/turmoil/">T</ListNavLink>
	<ListNavLink href="/sloth/">S</ListNavLink>
	<ListNavLink href="/cold/">C</ListNavLink>
	<ListNavLink href="/death-scale/">D</ListNavLink>
	<ListNavLink href="/misfortune/">M</ListNavLink>
	<ListNavLink href="/drain/">D</ListNavLink>

	<ListNavLink href="/chassis/">chassis</ListNavLink>
	<ListNavLink href="/nation/">nation</ListNavLink>

	<ListNavLink href="/male/">male</ListNavLink>
	<ListNavLink href="/female/">female</ListNavLink>
	<ListNavLink href="/undead/">undead</ListNavLink>
	<ListNavLink href="/demon/">demon</ListNavLink>
	<ListNavLink href="/immobile/">immobile</ListNavLink>
	<ListNavLink href="/inanimate/">inanimate</ListNavLink>
	<ListNavLink href="/disciple/">disciple</ListNavLink>
	<ListNavLink href="/special/">special</ListNavLink>

</ul>


<style>
	ul.listnav {
		list-style:none;
		text-align:center;
		padding:0;
		margin:0 80px;
		display: inline-block;
	}
	@media (max-width: 560px) {
		ul.listnav {
			margin:0;
		}
	}
</style>
