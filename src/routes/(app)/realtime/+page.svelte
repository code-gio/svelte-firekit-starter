<script lang="ts">
	import PageHeader from '$lib/components/showcase/page-header.svelte';
	import DemoSection from '$lib/components/showcase/demo-section.svelte';
	import { Button } from '$lib/components/ui/button/index.js';
	import { Input } from '$lib/components/ui/input/index.js';
	import { firekitNode, firekitNodeList, firekitUser, Node } from 'svelte-firekit';
	import { toast } from 'svelte-sonner';

	const counterPath = $derived(`firekit-demo/${firekitUser.uid}/counter`);
	const messagesPath = $derived(`firekit-demo/${firekitUser.uid}/messages`);

	const counter = $derived(firekitNode<number>(counterPath));
	const messages = $derived(firekitNodeList<{ text: string; timestamp: number; key: string }>(messagesPath));

	let newMessage = $state('');

	async function setCounter(value: number) {
		try {
			await counter.set(value);
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function incrementCounter() {
		const current = counter.data ?? 0;
		await counter.set(current + 1);
	}

	async function decrementCounter() {
		const current = counter.data ?? 0;
		await counter.set(current - 1);
	}

	async function removeCounter() {
		try {
			await counter.set(null);
			toast.success('Counter removed');
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function pushMessage() {
		if (!newMessage.trim()) return;
		try {
			await messages.push({
				text: newMessage.trim(),
				timestamp: Date.now()
			});
			newMessage = '';
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function clearMessages() {
		try {
			await messages.remove();
			toast.success('Messages cleared');
		} catch (e: any) {
			toast.error(e.message);
		}
	}
</script>

<PageHeader
	title="Realtime Database"
	description="Subscribe to RTDB nodes with firekitNode and firekitNodeList for real-time data sync."
/>

<div class="flex flex-col gap-6 px-4 lg:px-6">
	<DemoSection
		title="Node Read/Write"
		description="firekitNode() subscribes to a single RTDB path and keeps data in sync. Use set(), update(), and remove() to write."
		code={`<script lang="ts">
  import { firekitNode, firekitUser } from 'svelte-firekit';

  const path = 'firekit-demo/' + firekitUser.uid + '/counter';
  const counter = firekitNode<number>(path);

  // Reactive properties
  // counter.data    → number | null
  // counter.loading → boolean

  // Write operations
  await counter.set(42);
  await counter.update({ nested: 'value' });
  await counter.set(null); // remove
</script>

<p>Counter: {counter.data}</p>`}
	>
		<div class="space-y-4">
			<div class="flex items-center gap-4">
				<span class="text-muted-foreground text-sm">Value:</span>
				<span class="font-mono text-2xl font-bold">{counter.data ?? 'null'}</span>
			</div>
			<div class="flex flex-wrap gap-2">
				<Button variant="outline" size="sm" onclick={decrementCounter}>- 1</Button>
				<Button variant="outline" size="sm" onclick={incrementCounter}>+ 1</Button>
				<Button variant="outline" size="sm" onclick={() => setCounter(0)}>Reset to 0</Button>
				<Button variant="destructive" size="sm" onclick={removeCounter}>Remove</Button>
			</div>
			<div class="rounded-lg border p-3">
				<p class="text-muted-foreground text-xs">loading</p>
				<p class="font-mono text-sm">{counter.loading}</p>
			</div>
		</div>
	</DemoSection>

	<DemoSection
		title="Node List"
		description="firekitNodeList() subscribes to an RTDB path as an ordered list. Use push() to add items with auto-generated keys."
		code={`<script lang="ts">
  import { firekitNodeList, firekitUser } from 'svelte-firekit';

  type Message = { text: string; timestamp: number; key: string };

  const path = 'firekit-demo/' + firekitUser.uid + '/messages';
  const messages = firekitNodeList<Message>(path);

  // messages.list    → Message[] (with auto key)
  // messages.loading → boolean

  // Push new item (auto-generated key)
  await messages.push({ text: 'Hello!', timestamp: Date.now() });

  // Remove all
  await messages.remove();
</script>

{#each messages.list as msg (msg.key)}
  <p>{msg.text}</p>
{/each}`}
	>
		<div class="space-y-4">
			<form
				class="flex gap-2"
				onsubmit={(e) => {
					e.preventDefault();
					pushMessage();
				}}
			>
				<Input bind:value={newMessage} placeholder="Type a message..." class="flex-1" />
				<Button type="submit" disabled={!newMessage.trim()}>Push</Button>
				<Button variant="destructive" onclick={clearMessages}>Clear All</Button>
			</form>

			{#if messages.loading}
				<p class="text-muted-foreground text-sm">Loading...</p>
			{:else if !messages.list || messages.list.length === 0}
				<p class="text-muted-foreground text-sm">No messages yet. Push one above!</p>
			{:else}
				<div class="space-y-2">
					{#each messages.list as msg (msg.key)}
						<div class="flex items-center gap-3 rounded-lg border p-3">
							<span class="flex-1 text-sm">{msg.text}</span>
							<span class="text-muted-foreground font-mono text-xs">
								{new Date(msg.timestamp).toLocaleTimeString()}
							</span>
						</div>
					{/each}
				</div>
			{/if}
		</div>
	</DemoSection>

	<DemoSection
		title="Node Component"
		description="The <Node> component provides a declarative way to subscribe to RTDB paths."
		code={`<script lang="ts">
  import { Node, firekitUser } from 'svelte-firekit';
</script>

<Node path={'firekit-demo/' + firekitUser.uid + '/counter'}>
  {#snippet loading()}
    <p>Loading...</p>
  {/snippet}
  {#snippet data(value)}
    <p>Counter: {value}</p>
  {/snippet}
  {#snippet error(err)}
    <p>Error: {err.message}</p>
  {/snippet}
</Node>`}
	>
		<Node path={counterPath}>
			{#snippet loading()}
				<div class="rounded-lg border p-4">
					<p class="text-muted-foreground text-sm">Loading node...</p>
				</div>
			{/snippet}
			{#snippet data(value: any)}
				<div class="rounded-lg border border-green-500/30 bg-green-500/10 p-4">
					<p class="text-sm font-medium text-green-600 dark:text-green-400">Node loaded</p>
					<p class="mt-1 font-mono text-sm">Value: {JSON.stringify(value)}</p>
				</div>
			{/snippet}
			{#snippet error(err: Error)}
				<div class="rounded-lg border border-red-500/30 bg-red-500/10 p-4">
					<p class="text-sm text-red-500">Error: {err.message}</p>
				</div>
			{/snippet}
		</Node>
	</DemoSection>
</div>
