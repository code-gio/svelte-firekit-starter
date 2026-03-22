<script lang="ts">
	import PageHeader from '$lib/components/showcase/page-header.svelte';
	import DemoSection from '$lib/components/showcase/demo-section.svelte';
	import { Button } from '$lib/components/ui/button/index.js';
	import { Badge } from '$lib/components/ui/badge/index.js';
	import { firekitCollection, firekitUser, Collection, FirekitQueryBuilder } from 'svelte-firekit';
	import { where, orderBy } from 'firebase/firestore';

	type Todo = { id: string; text: string; completed: boolean; createdAt: any };

	const basePath = $derived(`firekit-demo/${firekitUser.uid}/todos`);

	// Basic collection
	const allTodos = $derived(firekitCollection<Todo>(basePath));

	// Filtered with query constraints
	const activeTodos = $derived(
		firekitCollection<Todo>(basePath, [where('completed', '==', false)])
	);
	const completedTodos = $derived(
		firekitCollection<Todo>(basePath, [where('completed', '==', true)])
	);

	let filter = $state<'all' | 'active' | 'completed'>('all');
	const filteredTodos = $derived(
		filter === 'all' ? allTodos : filter === 'active' ? activeTodos : completedTodos
	);
</script>

<PageHeader
	title="Firestore Collections"
	description="Subscribe to Firestore collections with real-time updates, query constraints, and pagination."
/>

<div class="flex flex-col gap-6 px-4 lg:px-6">
	<DemoSection
		title="Real-time Collection"
		description="firekitCollection() subscribes to a collection with optional query constraints. Data updates in real-time."
		code={`<script lang="ts">
  import { firekitCollection, firekitUser } from 'svelte-firekit';
  import { where } from 'firebase/firestore';

  type Todo = { text: string; completed: boolean };
  const path = 'firekit-demo/' + firekitUser.uid + '/todos';

  // All documents
  const all = firekitCollection<Todo>(path);

  // With query constraints
  const active = firekitCollection<Todo>(path, [
    where('completed', '==', false)
  ]);

  // Reactive properties
  // all.data     → Todo[]
  // all.loading  → boolean
  // all.error    → Error | null
  // all.count    → number
</script>

{#each all.data as todo (todo.id)}
  <p>{todo.text} - {todo.completed}</p>
{/each}`}
	>
		<div class="space-y-4">
			<div class="flex gap-2">
				<Button
					variant={filter === 'all' ? 'default' : 'outline'}
					size="sm"
					onclick={() => (filter = 'all')}
				>
					All ({allTodos.count})
				</Button>
				<Button
					variant={filter === 'active' ? 'default' : 'outline'}
					size="sm"
					onclick={() => (filter = 'active')}
				>
					Active ({activeTodos.count})
				</Button>
				<Button
					variant={filter === 'completed' ? 'default' : 'outline'}
					size="sm"
					onclick={() => (filter = 'completed')}
				>
					Completed ({completedTodos.count})
				</Button>
			</div>

			{#if filteredTodos.loading}
				<p class="text-muted-foreground text-sm">Loading...</p>
			{:else if filteredTodos.data.length === 0}
				<p class="text-muted-foreground text-sm">
					No {filter === 'all' ? '' : filter} todos found. Create some on the Mutations page.
				</p>
			{:else}
				<div class="space-y-2">
					{#each filteredTodos.data as todo (todo.id)}
						<div class="flex items-center gap-3 rounded-lg border p-3">
							<Badge variant={todo.completed ? 'default' : 'secondary'}>
								{todo.completed ? 'Done' : 'Active'}
							</Badge>
							<span class="flex-1 {todo.completed ? 'text-muted-foreground line-through' : ''}">
								{todo.text}
							</span>
							<span class="text-muted-foreground font-mono text-xs">{todo.id}</span>
						</div>
					{/each}
				</div>
			{/if}
		</div>
	</DemoSection>

	<DemoSection
		title="FirekitQueryBuilder"
		description="Build complex queries with a fluent API. Chain where, orderBy, limit, and more."
		code={`<script lang="ts">
  import { firekitCollection, FirekitQueryBuilder } from 'svelte-firekit';

  // Build query with fluent API
  const query = new FirekitQueryBuilder()
    .where('completed', '==', false)
    .orderBy('createdAt', 'desc')
    .limit(10)
    .build();

  const todos = firekitCollection('path/to/todos', query);
</script>`}
		lang="typescript"
	>
		<div class="space-y-3">
			<div class="rounded-lg border p-3">
				<p class="text-muted-foreground text-xs">QueryBuilder example</p>
				<pre class="mt-1 text-sm">new FirekitQueryBuilder()
  .where('completed', '==', false)
  .orderBy('createdAt', 'desc')
  .limit(10)
  .build()</pre>
			</div>
			<p class="text-muted-foreground text-sm">
				The QueryBuilder is useful when you need to build queries dynamically based on user input or application state.
			</p>
		</div>
	</DemoSection>

	<DemoSection
		title="Collection Component"
		description="The <Collection> component provides a declarative way to subscribe to collections with loading and error states."
		code={`<script lang="ts">
  import { Collection, firekitUser } from 'svelte-firekit';
</script>

<Collection path={'firekit-demo/' + firekitUser.uid + '/todos'}>
  {#snippet loading()}
    <p>Loading...</p>
  {/snippet}
  {#snippet data(todos)}
    {#each todos as todo (todo.id)}
      <p>{todo.text}</p>
    {/each}
  {/snippet}
  {#snippet error(err)}
    <p>Error: {err.message}</p>
  {/snippet}
</Collection>`}
	>
		<Collection path={basePath}>
			{#snippet loading()}
				<div class="rounded-lg border p-4">
					<p class="text-muted-foreground text-sm">Loading collection...</p>
				</div>
			{/snippet}
			{#snippet data(todos: Todo[])}
				<div class="rounded-lg border border-green-500/30 bg-green-500/10 p-4">
					<p class="text-sm font-medium text-green-600 dark:text-green-400">
						Collection loaded: {todos.length} documents
					</p>
					{#each todos.slice(0, 3) as todo (todo.id)}
						<p class="text-sm mt-1">- {todo.text}</p>
					{/each}
					{#if todos.length > 3}
						<p class="text-muted-foreground text-sm mt-1">...and {todos.length - 3} more</p>
					{/if}
				</div>
			{/snippet}
			{#snippet error(err: Error)}
				<div class="rounded-lg border border-red-500/30 bg-red-500/10 p-4">
					<p class="text-sm text-red-500">Error: {err.message}</p>
				</div>
			{/snippet}
		</Collection>
	</DemoSection>
</div>
