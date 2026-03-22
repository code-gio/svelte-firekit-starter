<script lang="ts">
	import PageHeader from '$lib/components/showcase/page-header.svelte';
	import DemoSection from '$lib/components/showcase/demo-section.svelte';
	import { Button } from '$lib/components/ui/button/index.js';
	import { Input } from '$lib/components/ui/input/index.js';
	import { Label } from '$lib/components/ui/label/index.js';
	import { firekitUser, firekitAuth, SignedIn, SignedOut } from 'svelte-firekit';
	import { toast } from 'svelte-sonner';

	let displayName = $state(firekitUser.displayName || '');
	let photoURL = $state(firekitUser.photoURL || '');
	let updating = $state(false);

	async function updateProfile() {
		updating = true;
		try {
			await firekitUser.updateProfile({ displayName, photoURL: photoURL || undefined });
			toast.success('Profile updated successfully');
		} catch (e: any) {
			toast.error(e.message);
		} finally {
			updating = false;
		}
	}
</script>

<PageHeader
	title="Authentication"
	description="User state management, profile updates, and conditional rendering with svelte-firekit auth."
/>

<div class="flex flex-col gap-6 px-4 lg:px-6">
	<DemoSection
		title="Reactive User State"
		description="firekitUser provides reactive getters that update automatically when auth state changes."
		code={`<script lang="ts">
  import { firekitUser } from 'svelte-firekit';
</script>

<p>Name: {firekitUser.displayName}</p>
<p>Email: {firekitUser.email}</p>
<p>UID: {firekitUser.uid}</p>
<p>Verified: {firekitUser.isEmailVerified}</p>
<p>Anonymous: {firekitUser.isAnonymous}</p>
<p>Authenticated: {firekitUser.isAuthenticated}</p>`}
	>
		<div class="grid grid-cols-1 gap-3 sm:grid-cols-2">
			<div class="rounded-lg border p-3">
				<p class="text-muted-foreground text-xs">displayName</p>
				<p class="font-medium">{firekitUser.displayName || 'Not set'}</p>
			</div>
			<div class="rounded-lg border p-3">
				<p class="text-muted-foreground text-xs">email</p>
				<p class="font-medium">{firekitUser.email || 'Not set'}</p>
			</div>
			<div class="rounded-lg border p-3">
				<p class="text-muted-foreground text-xs">uid</p>
				<p class="font-mono text-sm">{firekitUser.uid || '...'}</p>
			</div>
			<div class="rounded-lg border p-3">
				<p class="text-muted-foreground text-xs">isEmailVerified</p>
				<p class="font-medium">{firekitUser.isEmailVerified}</p>
			</div>
			<div class="rounded-lg border p-3">
				<p class="text-muted-foreground text-xs">isAnonymous</p>
				<p class="font-medium">{firekitUser.isAnonymous}</p>
			</div>
			<div class="rounded-lg border p-3">
				<p class="text-muted-foreground text-xs">isAuthenticated</p>
				<p class="font-medium">{firekitUser.isAuthenticated}</p>
			</div>
		</div>
	</DemoSection>

	<DemoSection
		title="Update Profile"
		description="Use firekitUser.updateProfile() to update the display name and photo URL."
		code={`<script lang="ts">
  import { firekitUser } from 'svelte-firekit';

  let displayName = $state(firekitUser.displayName || '');
  let photoURL = $state(firekitUser.photoURL || '');

  async function updateProfile() {
    await firekitUser.updateProfile({
      displayName,
      photoURL: photoURL || undefined
    });
  }
</script>

<input bind:value={displayName} placeholder="Display Name" />
<input bind:value={photoURL} placeholder="Photo URL" />
<button onclick={updateProfile}>Update Profile</button>`}
	>
		<form
			class="flex flex-col gap-4"
			onsubmit={(e) => {
				e.preventDefault();
				updateProfile();
			}}
		>
			<div class="grid gap-2">
				<Label for="displayName">Display Name</Label>
				<Input id="displayName" bind:value={displayName} placeholder="Enter display name" />
			</div>
			<div class="grid gap-2">
				<Label for="photoURL">Photo URL</Label>
				<Input id="photoURL" bind:value={photoURL} placeholder="https://example.com/photo.jpg" />
			</div>
			<Button type="submit" disabled={updating} class="w-fit">
				{updating ? 'Updating...' : 'Update Profile'}
			</Button>
		</form>
	</DemoSection>

	<DemoSection
		title="SignedIn / SignedOut Components"
		description="Conditionally render content based on authentication state using declarative components."
		code={`<script lang="ts">
  import { SignedIn, SignedOut } from 'svelte-firekit';
</script>

<SignedIn>
  {#snippet children(user)}
    <p>Welcome, {user.displayName}!</p>
  {/snippet}
</SignedIn>

<SignedOut>
  {#snippet children()}
    <p>Please sign in to continue.</p>
  {/snippet}
</SignedOut>`}
	>
		<div class="space-y-4">
			<SignedIn>
				{#snippet children(user)}
					<div class="rounded-lg border border-green-500/30 bg-green-500/10 p-4">
						<p class="text-sm font-medium text-green-600 dark:text-green-400">SignedIn content visible</p>
						<p class="text-muted-foreground mt-1 text-sm">Welcome, {user.displayName || user.email}!</p>
					</div>
				{/snippet}
			</SignedIn>
			<SignedOut>
				{#snippet children()}
					<div class="rounded-lg border border-yellow-500/30 bg-yellow-500/10 p-4">
						<p class="text-sm font-medium text-yellow-600 dark:text-yellow-400">SignedOut content visible</p>
						<p class="text-muted-foreground mt-1 text-sm">Please sign in to continue.</p>
					</div>
				{/snippet}
			</SignedOut>
		</div>
	</DemoSection>
</div>
