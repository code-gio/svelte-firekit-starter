<script lang="ts">
	import { Badge } from '$lib/components/ui/badge/index.js';
	import { Button } from '$lib/components/ui/button/index.js';
	import CopyIcon from '@tabler/icons-svelte/icons/copy';
	import CheckIcon from '@tabler/icons-svelte/icons/check';

	let { code, lang = 'svelte' }: { code: string; lang?: string } = $props();

	let copied = $state(false);

	async function copyCode() {
		await navigator.clipboard.writeText(code);
		copied = true;
		setTimeout(() => (copied = false), 2000);
	}
</script>

<div class="relative">
	<div class="flex items-center justify-between rounded-t-lg border border-b-0 bg-muted/50 px-4 py-2">
		<Badge variant="secondary">{lang}</Badge>
		<Button variant="ghost" size="sm" class="h-7 gap-1.5 text-xs" onclick={copyCode}>
			{#if copied}
				<CheckIcon class="size-3.5" />
				Copied
			{:else}
				<CopyIcon class="size-3.5" />
				Copy
			{/if}
		</Button>
	</div>
	<pre class="overflow-x-auto rounded-b-lg border bg-muted/30 p-4 text-sm leading-relaxed"><code
			>{code.trim()}</code
		></pre>
</div>
