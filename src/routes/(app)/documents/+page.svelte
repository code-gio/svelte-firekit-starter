<script lang="ts">
	import PageHeader from '$lib/components/showcase/page-header.svelte';
	import DemoSection from '$lib/components/showcase/demo-section.svelte';
	import { Button } from '$lib/components/ui/button/index.js';
	import { Input } from '$lib/components/ui/input/index.js';
	import { firekitDoc, firekitDocOnce, firekitMutations, firekitUser, Doc } from 'svelte-firekit';
	import { toast } from 'svelte-sonner';

	const docPath = $derived(`firekit-demo/${firekitUser.uid}/profile`);

	const profileDoc = $derived(firekitDoc<{ name: string; bio: string; updatedAt: any }>(docPath));
	const profileOnce = $derived(firekitDocOnce<{ name: string; bio: string; updatedAt: any }>(docPath));

	let name = $state('');
	let bio = $state('');

	async function saveProfile() {
		try {
			await firekitMutations.set(docPath, {
				name: name || 'Anonymous',
				bio: bio || 'No bio yet',
				updatedAt: firekitMutations.serverTimestamp()
			});
			toast.success('Document saved');
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function deleteProfile() {
		try {
			await firekitMutations.delete(docPath);
			toast.success('Document deleted');
		} catch (e: any) {
			toast.error(e.message);
		}
	}
</script>

<PageHeader
	title="Firestore Documents"
	description="Subscribe to individual Firestore documents with real-time updates, one-time fetches, and the Doc component."
/>

<div class="flex flex-col gap-6 px-4 lg:px-6">
	<DemoSection
		title="Real-time Document Subscription"
		description="firekitDoc() creates a reactive subscription that updates automatically when the document changes."
		code={`<script lang="ts">
  import { firekitDoc, firekitUser } from 'svelte-firekit';

  type Profile = { name: string; bio: string; updatedAt: any };

  const path = 'firekit-demo/' + firekitUser.uid + '/profile';
  const doc = firekitDoc<Profile>(path);
</script>

<!-- Reactive properties -->
<p>Loading: {doc.loading}</p>
<p>Exists: {doc.exists}</p>
<p>Data: {JSON.stringify(doc.data)}</p>
<p>Error: {doc.error}</p>`}
	>
		<div class="space-y-4">
			<div class="flex flex-wrap gap-2">
				<form
					class="flex flex-1 gap-2"
					onsubmit={(e) => {
						e.preventDefault();
						saveProfile();
					}}
				>
					<Input bind:value={name} placeholder="Name" class="flex-1" />
					<Input bind:value={bio} placeholder="Bio" class="flex-1" />
					<Button type="submit">Save Doc</Button>
				</form>
				<Button variant="destructive" onclick={deleteProfile}>Delete</Button>
			</div>

			<div class="grid grid-cols-1 gap-3 sm:grid-cols-2">
				<div class="rounded-lg border p-3">
					<p class="text-muted-foreground text-xs">loading</p>
					<p class="font-mono text-sm">{profileDoc.loading}</p>
				</div>
				<div class="rounded-lg border p-3">
					<p class="text-muted-foreground text-xs">exists</p>
					<p class="font-mono text-sm">{profileDoc.exists}</p>
				</div>
				<div class="col-span-full rounded-lg border p-3">
					<p class="text-muted-foreground text-xs">data</p>
					<pre class="mt-1 text-sm">{JSON.stringify(profileDoc.data, null, 2)}</pre>
				</div>
				{#if profileDoc.error}
					<div class="col-span-full rounded-lg border border-red-500/30 p-3">
						<p class="text-muted-foreground text-xs">error</p>
						<p class="text-sm text-red-500">{profileDoc.error.message}</p>
					</div>
				{/if}
			</div>
		</div>
	</DemoSection>

	<DemoSection
		title="One-time Fetch"
		description="firekitDocOnce() fetches a document once without establishing a real-time listener."
		code={`<script lang="ts">
  import { firekitDocOnce, firekitUser } from 'svelte-firekit';

  type Profile = { name: string; bio: string };

  const path = 'firekit-demo/' + firekitUser.uid + '/profile';
  const doc = firekitDocOnce<Profile>(path);

  // Manually refresh
  doc.refresh();
</script>

<p>Data: {JSON.stringify(doc.data)}</p>`}
	>
		<div class="space-y-4">
			<Button variant="outline" onclick={() => profileOnce.refresh()}>Refresh</Button>
			<div class="rounded-lg border p-3">
				<p class="text-muted-foreground text-xs">data (fetched once)</p>
				<pre class="mt-1 text-sm">{JSON.stringify(profileOnce.data, null, 2)}</pre>
			</div>
		</div>
	</DemoSection>

	<DemoSection
		title="Doc Component"
		description="The <Doc> component provides a declarative way to subscribe to documents with loading, error, and missing states."
		code={`<script lang="ts">
  import { Doc, firekitUser } from 'svelte-firekit';
</script>

<Doc path={'firekit-demo/' + firekitUser.uid + '/profile'}>
  {#snippet loading()}
    <p>Loading document...</p>
  {/snippet}
  {#snippet data(profile)}
    <p>Name: {profile.name}</p>
    <p>Bio: {profile.bio}</p>
  {/snippet}
  {#snippet missing()}
    <p>Document does not exist.</p>
  {/snippet}
  {#snippet error(err)}
    <p>Error: {err.message}</p>
  {/snippet}
</Doc>`}
	>
		<Doc path={docPath}>
			{#snippet loading()}
				<div class="rounded-lg border p-4">
					<p class="text-muted-foreground text-sm">Loading document...</p>
				</div>
			{/snippet}
			{#snippet data(profile: any)}
				<div class="rounded-lg border border-green-500/30 bg-green-500/10 p-4">
					<p class="text-sm font-medium text-green-600 dark:text-green-400">Document loaded</p>
					<p class="mt-1 text-sm">Name: {profile.name}</p>
					<p class="text-sm">Bio: {profile.bio}</p>
				</div>
			{/snippet}
			{#snippet missing()}
				<div class="rounded-lg border border-yellow-500/30 bg-yellow-500/10 p-4">
					<p class="text-sm font-medium text-yellow-600 dark:text-yellow-400">Document does not exist</p>
					<p class="text-muted-foreground mt-1 text-sm">Use the "Save Doc" button above to create it.</p>
				</div>
			{/snippet}
			{#snippet error(err: Error)}
				<div class="rounded-lg border border-red-500/30 bg-red-500/10 p-4">
					<p class="text-sm text-red-500">Error: {err.message}</p>
				</div>
			{/snippet}
		</Doc>
	</DemoSection>
</div>
