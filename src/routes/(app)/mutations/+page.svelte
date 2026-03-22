<script lang="ts">
	import PageHeader from '$lib/components/showcase/page-header.svelte';
	import DemoSection from '$lib/components/showcase/demo-section.svelte';
	import { Button } from '$lib/components/ui/button/index.js';
	import { Input } from '$lib/components/ui/input/index.js';
	import { Badge } from '$lib/components/ui/badge/index.js';
	import { firekitMutations, firekitCollection, firekitUser } from 'svelte-firekit';
	import { toast } from 'svelte-sonner';
	import { where } from 'firebase/firestore';

	let newTodoText = $state('');
	let editingId = $state<string | null>(null);
	let editText = $state('');

	const basePath = $derived(`firekit-demo/${firekitUser.uid}/todos`);
	const todos = $derived(firekitCollection<{ text: string; completed: boolean; createdAt: any }>(basePath));

	async function addTodo() {
		if (!newTodoText.trim()) return;
		try {
			await firekitMutations.add(basePath, {
				text: newTodoText.trim(),
				completed: false
			}, { timestamps: true, userId: firekitUser.uid });
			newTodoText = '';
			toast.success('Todo added');
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function toggleTodo(id: string, completed: boolean) {
		try {
			await firekitMutations.update(`${basePath}/${id}`, { completed: !completed });
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function deleteTodo(id: string) {
		try {
			await firekitMutations.delete(`${basePath}/${id}`);
			toast.success('Todo deleted');
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function updateTodo(id: string) {
		if (!editText.trim()) return;
		try {
			await firekitMutations.update(`${basePath}/${id}`, { text: editText.trim() });
			editingId = null;
			editText = '';
			toast.success('Todo updated');
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	// Field helpers demo
	const counterPath = $derived(`firekit-demo/${firekitUser.uid}/counters/demo`);

	async function initCounter() {
		try {
			await firekitMutations.set(counterPath, {
				count: 0,
				tags: [],
			}, { timestamps: true });
			toast.success('Counter initialized');
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function incrementCounter() {
		try {
			await firekitMutations.update(counterPath, {
				count: firekitMutations.increment(1)
			});
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function decrementCounter() {
		try {
			await firekitMutations.update(counterPath, {
				count: firekitMutations.increment(-1)
			});
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function addTag(tag: string) {
		try {
			await firekitMutations.update(counterPath, {
				tags: firekitMutations.arrayUnion(tag)
			});
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function removeTag(tag: string) {
		try {
			await firekitMutations.update(counterPath, {
				tags: firekitMutations.arrayRemove(tag)
			});
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function setTimestamp() {
		try {
			await firekitMutations.update(counterPath, {
				lastUpdated: firekitMutations.serverTimestamp()
			});
			toast.success('Server timestamp set');
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	// Batch demo
	async function batchCreateTodos() {
		const ops = Array.from({ length: 5 }, (_, i) => ({
			type: 'set' as const,
			path: `${basePath}/batch-${Date.now()}-${i}`,
			data: { text: `Batch todo #${i + 1}`, completed: false }
		}));
		try {
			const result = await firekitMutations.batchOps(ops);
			toast.success(`Batch created ${result.count} todos`);
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function batchDeleteAll() {
		if (!todos.data.length) return;
		const ops = todos.data.map((todo: any) => ({
			type: 'delete' as const,
			path: `${basePath}/${todo.id}`
		}));
		try {
			const result = await firekitMutations.batchOps(ops);
			toast.success(`Batch deleted ${result.count} todos`);
		} catch (e: any) {
			toast.error(e.message);
		}
	}
</script>

<PageHeader
	title="Mutations"
	description="Write, update, and delete Firestore documents with firekitMutations."
/>

<div class="flex flex-col gap-6 px-4 lg:px-6">
	<DemoSection
		title="CRUD Operations"
		description="Add, update, and delete documents using firekitMutations."
		code={`<script lang="ts">
  import { firekitMutations, firekitCollection } from 'svelte-firekit';

  const todos = firekitCollection('firekit-demo/USER_ID/todos');

  // Add
  await firekitMutations.add('firekit-demo/USER_ID/todos', {
    text: 'My todo',
    completed: false
  }, { timestamps: true, userId: 'USER_ID' });

  // Update
  await firekitMutations.update('firekit-demo/USER_ID/todos/DOC_ID', {
    text: 'Updated text'
  });

  // Delete
  await firekitMutations.delete('firekit-demo/USER_ID/todos/DOC_ID');
</script>`}
		lang="typescript"
	>
		<div class="space-y-4">
			<form
				class="flex gap-2"
				onsubmit={(e) => {
					e.preventDefault();
					addTodo();
				}}
			>
				<Input bind:value={newTodoText} placeholder="Add a new todo..." class="flex-1" />
				<Button type="submit" disabled={!newTodoText.trim()}>Add</Button>
			</form>

			{#if todos.loading}
				<p class="text-muted-foreground text-sm">Loading...</p>
			{:else if todos.data.length === 0}
				<p class="text-muted-foreground text-sm">No todos yet. Add one above!</p>
			{:else}
				<div class="space-y-2">
					{#each todos.data as todo (todo.id)}
						<div class="flex items-center gap-3 rounded-lg border p-3">
							<button
								class="size-5 flex-shrink-0 rounded border {todo.completed
									? 'bg-primary border-primary'
									: ''}"
								onclick={() => toggleTodo(todo.id, todo.completed)}
							></button>
							{#if editingId === todo.id}
								<form
									class="flex flex-1 gap-2"
									onsubmit={(e) => {
										e.preventDefault();
										updateTodo(todo.id);
									}}
								>
									<Input bind:value={editText} class="flex-1" />
									<Button type="submit" size="sm">Save</Button>
									<Button type="button" variant="ghost" size="sm" onclick={() => (editingId = null)}>Cancel</Button>
								</form>
							{:else}
								<span class="flex-1 {todo.completed ? 'text-muted-foreground line-through' : ''}">{todo.text}</span>
								<Button
									variant="ghost"
									size="sm"
									onclick={() => {
										editingId = todo.id;
										editText = todo.text;
									}}>Edit</Button>
								<Button variant="ghost" size="sm" onclick={() => deleteTodo(todo.id)}>Delete</Button>
							{/if}
						</div>
					{/each}
				</div>
			{/if}
		</div>
	</DemoSection>

	<DemoSection
		title="Field Helpers"
		description="Atomic operations: increment, arrayUnion, arrayRemove, serverTimestamp, deleteField."
		code={`<script lang="ts">
  import { firekitMutations } from 'svelte-firekit';

  const path = 'firekit-demo/USER_ID/counters/demo';

  // Initialize
  await firekitMutations.set(path, { count: 0, tags: [] });

  // Increment / Decrement
  await firekitMutations.update(path, {
    count: firekitMutations.increment(1)
  });

  // Array operations
  await firekitMutations.update(path, {
    tags: firekitMutations.arrayUnion('new-tag')
  });
  await firekitMutations.update(path, {
    tags: firekitMutations.arrayRemove('old-tag')
  });

  // Server timestamp
  await firekitMutations.update(path, {
    lastUpdated: firekitMutations.serverTimestamp()
  });
</script>`}
		lang="typescript"
	>
		<div class="space-y-4">
			<Button onclick={initCounter} variant="outline">Initialize Counter Doc</Button>

			<div class="flex items-center gap-4">
				<span class="text-muted-foreground text-sm">Counter:</span>
				<Button variant="outline" size="sm" onclick={decrementCounter}>-</Button>
				<Button variant="outline" size="sm" onclick={incrementCounter}>+</Button>
			</div>

			<div class="flex flex-wrap items-center gap-2">
				<span class="text-muted-foreground text-sm">Tags:</span>
				{#each ['svelte', 'firebase', 'typescript'] as tag}
					<Button variant="outline" size="sm" onclick={() => addTag(tag)}>+ {tag}</Button>
				{/each}
			</div>

			<Button variant="outline" size="sm" onclick={setTimestamp}>Set Server Timestamp</Button>
		</div>
	</DemoSection>

	<DemoSection
		title="Batch Operations"
		description="Execute multiple write operations atomically with firekitMutations.batchOps()."
		code={`<script lang="ts">
  import { firekitMutations } from 'svelte-firekit';

  const ops = [
    { type: 'set', path: 'todos/1', data: { text: 'Todo 1' } },
    { type: 'set', path: 'todos/2', data: { text: 'Todo 2' } },
    { type: 'delete', path: 'todos/old-1' },
  ];

  const result = await firekitMutations.batchOps(ops);
  // { success: true, count: 3 }
</script>`}
		lang="typescript"
	>
		<div class="flex flex-wrap gap-3">
			<Button onclick={batchCreateTodos}>Create 5 Todos (Batch)</Button>
			<Button variant="destructive" onclick={batchDeleteAll} disabled={!todos.data.length}>
				Delete All ({todos.data.length})
			</Button>
		</div>
	</DemoSection>
</div>
