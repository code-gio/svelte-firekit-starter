<script lang="ts">
	import { page } from "$app/state";
	import { Button } from "$lib/components/ui/button/index.js";
	import { Separator } from "$lib/components/ui/separator/index.js";
	import * as Sidebar from "$lib/components/ui/sidebar/index.js";

	const titles: Record<string, string> = {
		"/": "Overview",
		"/auth": "Authentication",
		"/documents": "Firestore Documents",
		"/collections": "Firestore Collections",
		"/mutations": "Mutations",
		"/realtime": "Realtime Database",
		"/storage": "Storage",
		"/presence": "Presence & Network",
	};

	let pageTitle = $derived(titles[page.url.pathname] ?? "Firekit Starter");
</script>

<header
	class="flex h-(--header-height) shrink-0 items-center gap-2 border-b transition-[width,height] ease-linear group-has-data-[collapsible=icon]/sidebar-wrapper:h-(--header-height)"
>
	<div class="flex w-full items-center gap-1 px-4 lg:gap-2 lg:px-6">
		<Sidebar.Trigger class="-ms-1" />
		<Separator orientation="vertical" class="mx-2 data-[orientation=vertical]:h-4" />
		<h1 class="text-base font-medium">{pageTitle}</h1>
		<div class="ms-auto flex items-center gap-2">
			<Button
				href="https://github.com/code-gio/svelte-firekit-starter"
				variant="ghost"
				size="sm"
				class="dark:text-foreground hidden sm:flex"
				target="_blank"
				rel="noopener noreferrer"
			>
				GitHub
			</Button>
		</div>
	</div>
</header>
