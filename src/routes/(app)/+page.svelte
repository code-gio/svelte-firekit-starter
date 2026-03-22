<script lang="ts">
	import PageHeader from '$lib/components/showcase/page-header.svelte';
	import * as Card from '$lib/components/ui/card/index.js';
	import { firekitUser } from 'svelte-firekit';
	import LockIcon from '@tabler/icons-svelte/icons/lock';
	import FileTextIcon from '@tabler/icons-svelte/icons/file-text';
	import ListIcon from '@tabler/icons-svelte/icons/list';
	import PencilIcon from '@tabler/icons-svelte/icons/pencil';
	import BoltIcon from '@tabler/icons-svelte/icons/bolt';
	import CloudUploadIcon from '@tabler/icons-svelte/icons/cloud-upload';
	import WifiIcon from '@tabler/icons-svelte/icons/wifi';

	const features = [
		{
			title: 'Authentication',
			description: 'User state, profile updates, SignedIn/SignedOut components',
			href: '/auth',
			icon: LockIcon
		},
		{
			title: 'Firestore Documents',
			description: 'Real-time document subscriptions, one-time fetches, Doc component',
			href: '/documents',
			icon: FileTextIcon
		},
		{
			title: 'Firestore Collections',
			description: 'Collection queries, QueryBuilder, pagination',
			href: '/collections',
			icon: ListIcon
		},
		{
			title: 'Mutations',
			description: 'CRUD operations, field helpers, batch writes',
			href: '/mutations',
			icon: PencilIcon
		},
		{
			title: 'Realtime Database',
			description: 'Node subscriptions, lists, push/set/update/remove',
			href: '/realtime',
			icon: BoltIcon
		},
		{
			title: 'Storage',
			description: 'File uploads with progress, download URLs, file listing',
			href: '/storage',
			icon: CloudUploadIcon
		},
		{
			title: 'Presence & Network',
			description: 'Online status, offline detection, presence tracking',
			href: '/presence',
			icon: WifiIcon
		}
	];
</script>

<PageHeader
	title="Welcome to Firekit Starter"
	description="An interactive reference app showcasing svelte-firekit features with live demos and code snippets."
/>

<div class="flex flex-col gap-6 px-4 lg:px-6">
	<Card.Root>
		<Card.Header>
			<Card.Title>Current User</Card.Title>
			<Card.Description>Live reactive state from firekitUser</Card.Description>
		</Card.Header>
		<Card.Content>
			<div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
				<div class="space-y-1">
					<p class="text-muted-foreground text-sm">Display Name</p>
					<p class="font-medium">{firekitUser.displayName || 'Not set'}</p>
				</div>
				<div class="space-y-1">
					<p class="text-muted-foreground text-sm">Email</p>
					<p class="font-medium">{firekitUser.email || 'Not set'}</p>
				</div>
				<div class="space-y-1">
					<p class="text-muted-foreground text-sm">UID</p>
					<p class="font-mono text-sm">{firekitUser.uid || '...'}</p>
				</div>
				<div class="space-y-1">
					<p class="text-muted-foreground text-sm">Email Verified</p>
					<p class="font-medium">{firekitUser.isEmailVerified ? 'Yes' : 'No'}</p>
				</div>
			</div>
		</Card.Content>
	</Card.Root>

	<div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
		{#each features as feature}
			<a href={feature.href} class="group">
				<Card.Root class="transition-colors group-hover:border-primary/50">
					<Card.Header>
						<div class="flex items-center gap-3">
							<div class="bg-primary/10 text-primary flex size-10 items-center justify-center rounded-lg">
								<feature.icon class="size-5" />
							</div>
							<Card.Title class="text-base">{feature.title}</Card.Title>
						</div>
						<Card.Description>{feature.description}</Card.Description>
					</Card.Header>
				</Card.Root>
			</a>
		{/each}
	</div>
</div>
