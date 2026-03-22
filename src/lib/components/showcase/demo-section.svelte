<script lang="ts">
	import * as Card from '$lib/components/ui/card/index.js';
	import * as Tabs from '$lib/components/ui/tabs/index.js';
	import CodeBlock from './code-block.svelte';
	import type { Snippet } from 'svelte';

	let {
		title,
		description,
		code,
		lang = 'svelte',
		children
	}: {
		title: string;
		description?: string;
		code: string;
		lang?: string;
		children: Snippet;
	} = $props();
</script>

<Card.Root>
	<Card.Header>
		<Card.Title>{title}</Card.Title>
		{#if description}
			<Card.Description>{description}</Card.Description>
		{/if}
	</Card.Header>
	<Card.Content>
		<Tabs.Root value="preview">
			<Tabs.List>
				<Tabs.Trigger value="preview">Preview</Tabs.Trigger>
				<Tabs.Trigger value="code">Code</Tabs.Trigger>
			</Tabs.List>
			<Tabs.Content value="preview" class="pt-4">
				{@render children()}
			</Tabs.Content>
			<Tabs.Content value="code" class="pt-4">
				<CodeBlock {code} {lang} />
			</Tabs.Content>
		</Tabs.Root>
	</Card.Content>
</Card.Root>
