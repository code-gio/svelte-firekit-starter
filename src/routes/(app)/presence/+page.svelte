<script lang="ts">
	import PageHeader from '$lib/components/showcase/page-header.svelte';
	import DemoSection from '$lib/components/showcase/demo-section.svelte';
	import { Button } from '$lib/components/ui/button/index.js';
	import { Badge } from '$lib/components/ui/badge/index.js';
	import { firekitNetwork, NetworkStatus } from 'svelte-firekit';
	import { toast } from 'svelte-sonner';

	async function goOffline() {
		try {
			await firekitNetwork.goOffline();
			toast.info('Firestore is now offline');
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	async function goOnline() {
		try {
			await firekitNetwork.goOnline();
			toast.info('Firestore is back online');
		} catch (e: any) {
			toast.error(e.message);
		}
	}
</script>

<PageHeader
	title="Presence & Network"
	description="Monitor network connectivity, Firestore sync state, and manage offline mode."
/>

<div class="flex flex-col gap-6 px-4 lg:px-6">
	<DemoSection
		title="Network Status"
		description="firekitNetwork provides reactive properties for monitoring connectivity and Firestore sync state."
		code={`<script lang="ts">
  import { firekitNetwork } from 'svelte-firekit';

  // Reactive properties
  // firekitNetwork.online           → boolean
  // firekitNetwork.synced           → boolean
  // firekitNetwork.hasPendingWrites → boolean
  // firekitNetwork.firestoreEnabled → boolean
  // firekitNetwork.initialized      → boolean

  // Control Firestore connectivity
  await firekitNetwork.goOffline();  // Queue writes locally
  await firekitNetwork.goOnline();   // Sync queued writes

  // Track pending writes
  firekitNetwork.trackWrite();
</script>

<p>Online: {firekitNetwork.online}</p>
<p>Synced: {firekitNetwork.synced}</p>`}
	>
		<div class="space-y-4">
			<div class="grid grid-cols-1 gap-3 sm:grid-cols-2">
				<div class="rounded-lg border p-3">
					<p class="text-muted-foreground text-xs">online</p>
					<div class="mt-1 flex items-center gap-2">
						<div class="size-2 rounded-full {firekitNetwork.online ? 'bg-green-500' : 'bg-red-500'}"></div>
						<p class="font-mono text-sm">{firekitNetwork.online}</p>
					</div>
				</div>
				<div class="rounded-lg border p-3">
					<p class="text-muted-foreground text-xs">synced</p>
					<p class="mt-1 font-mono text-sm">{firekitNetwork.synced}</p>
				</div>
				<div class="rounded-lg border p-3">
					<p class="text-muted-foreground text-xs">hasPendingWrites</p>
					<p class="mt-1 font-mono text-sm">{firekitNetwork.hasPendingWrites}</p>
				</div>
				<div class="rounded-lg border p-3">
					<p class="text-muted-foreground text-xs">firestoreEnabled</p>
					<p class="mt-1 font-mono text-sm">{firekitNetwork.firestoreEnabled}</p>
				</div>
			</div>

			<div class="flex gap-2">
				<Button variant="outline" size="sm" onclick={goOffline}>Go Offline</Button>
				<Button variant="outline" size="sm" onclick={goOnline}>Go Online</Button>
			</div>
		</div>
	</DemoSection>

	<DemoSection
		title="NetworkStatus Component"
		description="The <NetworkStatus> component renders different content based on connectivity state."
		code={`<script lang="ts">
  import { NetworkStatus } from 'svelte-firekit';
</script>

<NetworkStatus>
  {#snippet online()}
    <p>Connected and synced</p>
  {/snippet}
  {#snippet offline()}
    <p>You are offline</p>
  {/snippet}
  {#snippet pending()}
    <p>Syncing pending writes...</p>
  {/snippet}
</NetworkStatus>`}
	>
		<NetworkStatus>
			{#snippet online()}
				<div class="rounded-lg border border-green-500/30 bg-green-500/10 p-4">
					<div class="flex items-center gap-2">
						<div class="size-2 rounded-full bg-green-500"></div>
						<p class="text-sm font-medium text-green-600 dark:text-green-400">Connected & Synced</p>
					</div>
					<p class="text-muted-foreground mt-1 text-sm">All data is up to date.</p>
				</div>
			{/snippet}
			{#snippet offline()}
				<div class="rounded-lg border border-red-500/30 bg-red-500/10 p-4">
					<div class="flex items-center gap-2">
						<div class="size-2 rounded-full bg-red-500"></div>
						<p class="text-sm font-medium text-red-600 dark:text-red-400">Offline</p>
					</div>
					<p class="text-muted-foreground mt-1 text-sm">You are disconnected. Changes will sync when reconnected.</p>
				</div>
			{/snippet}
			{#snippet pending()}
				<div class="rounded-lg border border-yellow-500/30 bg-yellow-500/10 p-4">
					<div class="flex items-center gap-2">
						<div class="size-2 rounded-full bg-yellow-500 animate-pulse"></div>
						<p class="text-sm font-medium text-yellow-600 dark:text-yellow-400">Syncing</p>
					</div>
					<p class="text-muted-foreground mt-1 text-sm">Pending writes are being synchronized...</p>
				</div>
			{/snippet}
		</NetworkStatus>
	</DemoSection>
</div>
