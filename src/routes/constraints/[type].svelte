<script context="module">
	export async function load({ page, fetch, session, stuff }) {
		return { props: { ctype: page.params.type } };
	}
</script>

<script>
	export let ctype;
</script>

<main>
	the ctype is { ctype }
</main>

