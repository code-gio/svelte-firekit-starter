#!/usr/bin/env bash
#
# Removes all demo content from the Svelte Firekit Starter.
# Keeps: auth pages (sign-in, sign-up, forgot-password), app layout, sidebar, and all UI components.
# Removes: demo route pages, showcase components, and resets the overview page and sidebar nav.
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "Removing demo content from Svelte Firekit Starter..."
echo ""

# 1. Remove demo route pages (keep (auth) pages intact)
echo "[1/4] Removing demo route pages..."
rm -rf "$ROOT/src/routes/(app)/auth"
rm -rf "$ROOT/src/routes/(app)/documents"
rm -rf "$ROOT/src/routes/(app)/collections"
rm -rf "$ROOT/src/routes/(app)/mutations"
rm -rf "$ROOT/src/routes/(app)/realtime"
rm -rf "$ROOT/src/routes/(app)/storage"
rm -rf "$ROOT/src/routes/(app)/presence"

# 2. Remove showcase components (only used by demo pages)
echo "[2/4] Removing showcase components..."
rm -rf "$ROOT/src/lib/components/showcase"

# 3. Replace overview page with a clean starter
echo "[3/4] Replacing overview page..."
cat > "$ROOT/src/routes/(app)/+page.svelte" << 'SVELTE'
<script lang="ts">
	import { firekitUser } from 'svelte-firekit';
</script>

<div class="flex flex-col gap-6 px-4 lg:px-6">
	<div>
		<h1 class="text-2xl font-bold tracking-tight">Welcome{firekitUser.displayName ? `, ${firekitUser.displayName}` : ''}</h1>
		<p class="text-muted-foreground">Start building your app by editing this page.</p>
	</div>
</div>
SVELTE

# 4. Reset sidebar navigation
echo "[4/4] Updating sidebar navigation..."
cat > "$ROOT/src/lib/components/layout/app-sidebar.svelte" << 'SVELTE'
<script lang="ts">
	import DashboardIcon from "@tabler/icons-svelte/icons/dashboard";
	import HelpIcon from "@tabler/icons-svelte/icons/help";
	import BrandGithubIcon from "@tabler/icons-svelte/icons/brand-github";
	import FlameIcon from "@tabler/icons-svelte/icons/flame";
	import NavMain from "./nav-main.svelte";
	import NavSecondary from "./nav-secondary.svelte";
	import NavUser from "./nav-user.svelte";
	import * as Sidebar from "$lib/components/ui/sidebar/index.js";
	import type { ComponentProps } from "svelte";

	const data = {
		navMain: [
			{ title: "Home", url: "/", icon: DashboardIcon },
		],
		navSecondary: [
			{ title: "Firekit Docs", url: "https://sveltefirekit.com", icon: HelpIcon },
			{ title: "GitHub", url: "https://github.com/code-gio/svelte-firekit-starter", icon: BrandGithubIcon },
		],
	};

	let { ...restProps }: ComponentProps<typeof Sidebar.Root> = $props();
</script>

<Sidebar.Root collapsible="offcanvas" {...restProps}>
	<Sidebar.Header>
		<Sidebar.Menu>
			<Sidebar.MenuItem>
				<Sidebar.MenuButton class="data-[slot=sidebar-menu-button]:!p-1.5">
					{#snippet child({ props })}
						<a href="/" {...props}>
							<FlameIcon class="!size-5" />
							<span class="text-base font-semibold">My App</span>
						</a>
					{/snippet}
				</Sidebar.MenuButton>
			</Sidebar.MenuItem>
		</Sidebar.Menu>
	</Sidebar.Header>
	<Sidebar.Content>
		<NavMain items={data.navMain} />
		<NavSecondary items={data.navSecondary} class="mt-auto" />
	</Sidebar.Content>
	<Sidebar.Footer>
		<NavUser />
	</Sidebar.Footer>
</Sidebar.Root>
SVELTE

echo ""
echo "Done! Demo content has been removed."
echo ""
echo "What's left:"
echo "  - Auth pages: /sign-in, /sign-up, /forgot-password"
echo "  - App layout with sidebar and AuthGuard"
echo "  - All UI components in src/lib/components/ui/"
echo "  - Clean home page at /"
echo ""
echo "If you used the demo with a Firebase project, you can also clean up"
echo "the 'firekit-demo' path in Firestore, Realtime Database, and Storage"
echo "via the Firebase Console."
