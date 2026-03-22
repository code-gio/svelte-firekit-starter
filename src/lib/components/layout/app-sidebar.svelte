<script lang="ts">
	import BoltIcon from "@tabler/icons-svelte/icons/bolt";
	import CloudUploadIcon from "@tabler/icons-svelte/icons/cloud-upload";
	import DashboardIcon from "@tabler/icons-svelte/icons/dashboard";
	import FileTextIcon from "@tabler/icons-svelte/icons/file-text";
	import FlameIcon from "@tabler/icons-svelte/icons/flame";
	import HelpIcon from "@tabler/icons-svelte/icons/help";
	import BrandGithubIcon from "@tabler/icons-svelte/icons/brand-github";
	import ListIcon from "@tabler/icons-svelte/icons/list";
	import LockIcon from "@tabler/icons-svelte/icons/lock";
	import PencilIcon from "@tabler/icons-svelte/icons/pencil";
	import WifiIcon from "@tabler/icons-svelte/icons/wifi";
	import NavMain from "./nav-main.svelte";
	import NavSecondary from "./nav-secondary.svelte";
	import NavUser from "./nav-user.svelte";
	import * as Sidebar from "$lib/components/ui/sidebar/index.js";
	import type { ComponentProps } from "svelte";

	const data = {
		navMain: [
			{ title: "Overview", url: "/", icon: DashboardIcon },
			{ title: "Authentication", url: "/auth", icon: LockIcon },
			{ title: "Documents", url: "/documents", icon: FileTextIcon },
			{ title: "Collections", url: "/collections", icon: ListIcon },
			{ title: "Mutations", url: "/mutations", icon: PencilIcon },
			{ title: "Realtime DB", url: "/realtime", icon: BoltIcon },
			{ title: "Storage", url: "/storage", icon: CloudUploadIcon },
			{ title: "Presence", url: "/presence", icon: WifiIcon },
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
							<span class="text-base font-semibold">Firekit Starter</span>
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
