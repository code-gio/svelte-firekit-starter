<script lang="ts">
	let { title, description }: { title: string; description: string } = $props();
</script>

<div class="px-4 lg:px-6">
	<h1 class="text-2xl font-semibold tracking-tight">{title}</h1>
	<p class="text-muted-foreground mt-1">{description}</p>
</div>
