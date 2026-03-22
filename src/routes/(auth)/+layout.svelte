<script lang="ts">
	import { goto } from '$app/navigation';
	import { CustomGuard, type UserProfile } from 'svelte-firekit';

	let { children: page } = $props();
</script>

<CustomGuard requireAuth={false} onUnauthorized={() => goto('/')}>
	{#snippet children(_user: UserProfile | null, _signOut: () => Promise<void>)}
		<div class="relative min-h-svh w-full overflow-hidden bg-black">
			<div class="relative z-10 flex min-h-svh flex-col items-center justify-center gap-6 p-6 md:p-10">
				<div class="flex w-full max-w-sm flex-col gap-6">
					{@render page()}
				</div>
			</div>
		</div>
	{/snippet}
</CustomGuard>
