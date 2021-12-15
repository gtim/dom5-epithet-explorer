<script>
  import ListNavLink from '$lib/ListNavLink.svelte'
  import ListNavImageLink from '$lib/ListNavImageLink.svelte'
</script>

<ul class="listnav">
	<ListNavImageLink href="/fire/"   src="/img/Path_F.png" title="Fire" />
	<ListNavImageLink href="/air/"    src="/img/Path_A.png" title="Air"  />
	<ListNavImageLink href="/water/"  src="/img/Path_W.png" title="Water" />
	<ListNavImageLink href="/earth/"  src="/img/Path_E.png" title="Earth" />
	<ListNavImageLink href="/astral/" src="/img/Path_S.png" title="Astral" />
	<ListNavImageLink href="/death/"  src="/img/Path_D.png" title="Death" />
	<ListNavImageLink href="/nature/" src="/img/Path_N.png" title="Nature" />
	<ListNavImageLink href="/blood/"  src="/img/Path_B.png" title="Blood" />
</ul>
<br/>
<ul class="listnav">
	<ListNavImageLink href="/order/" src="/img/Scale_order.png" title="Order" />
	<ListNavImageLink href="/productivity/" src="/img/Scale_productivity.png" title="Productivity" />
	<ListNavImageLink href="/heat/" src="/img/Scale_heat.png" title="Heat" />
	<ListNavImageLink href="/growth/" src="/img/Scale_growth.png" title="Growth" />
	<ListNavImageLink href="/luck/" src="/img/Scale_luck.png" title="Luck" />
	<ListNavImageLink href="/magic/" src="/img/Scale_magic.png" title="Magic" />
</ul>
<br/>
<ul class="listnav">
	<ListNavImageLink href="/turmoil/" src="/img/Scale_turmoil.png" title="Turmoil" />
	<ListNavImageLink href="/sloth/" src="/img/Scale_sloth.png" title="Sloth" />
	<ListNavImageLink href="/cold/" src="/img/Scale_cold.png" title="Cold" />
	<ListNavImageLink href="/death-scale/" src="/img/Scale_death.png" title="Death" />
	<ListNavImageLink href="/misfortune/" src="/img/Scale_misfortune.png" title="Misfortune" />
	<ListNavImageLink href="/drain/" src="/img/Scale_drain.png" title="Drain" />
</ul>
<br/>
<ul class="listnav">
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
