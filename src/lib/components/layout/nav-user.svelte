<script lang="ts">
	import CreditCardIcon from "@tabler/icons-svelte/icons/credit-card";
	import DotsVerticalIcon from "@tabler/icons-svelte/icons/dots-vertical";
	import LogoutIcon from "@tabler/icons-svelte/icons/logout";
	import NotificationIcon from "@tabler/icons-svelte/icons/notification";
	import UserCircleIcon from "@tabler/icons-svelte/icons/user-circle";
	import * as Avatar from "$lib/components/ui/avatar/index.js";
	import * as DropdownMenu from "$lib/components/ui/dropdown-menu/index.js";
	import * as Sidebar from "$lib/components/ui/sidebar/index.js";
	import { firekitAuth, firekitUser } from "svelte-firekit";
	import { getUserInitials } from "$lib/utils.js";

	const sidebar = Sidebar.useSidebar();

	const displayLabel = $derived.by(() => {
		const u = firekitUser.user;
		const name = u?.displayName?.trim();
		if (name) return name;
		const mail = u?.email?.trim();
		if (mail) return mail.split("@")[0] ?? "User";
		return "User";
	});

	const email = $derived(firekitUser.user?.email ?? "");
	const photoURL = $derived(firekitUser.user?.photoURL);
	const initials = $derived(getUserInitials(firekitUser.user?.displayName, firekitUser.user?.email));
</script>

<Sidebar.Menu>
	<Sidebar.MenuItem>
		<DropdownMenu.Root>
			<DropdownMenu.Trigger>
				{#snippet child({ props })}
					<Sidebar.MenuButton
						{...props}
						size="lg"
						class="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
					>
						<Avatar.Root class="size-8 rounded-lg ">
							{#if photoURL}
								<Avatar.Image src={photoURL} alt={displayLabel} />
							{/if}
							<Avatar.Fallback class="rounded-lg">{initials}</Avatar.Fallback>
						</Avatar.Root>
						<div class="grid flex-1 text-start text-sm leading-tight">
							<span class="truncate font-medium">{displayLabel}</span>
							<span class="text-muted-foreground truncate text-xs">
								{email}
							</span>
						</div>
						<DotsVerticalIcon class="ms-auto size-4" />
					</Sidebar.MenuButton>
				{/snippet}
			</DropdownMenu.Trigger>
			<DropdownMenu.Content
				class="w-(--bits-dropdown-menu-anchor-width) min-w-56 rounded-lg"
				side={sidebar.isMobile ? "bottom" : "right"}
				align="end"
				sideOffset={4}
			>
				<DropdownMenu.Label class="p-0 font-normal">
					<div class="flex items-center gap-2 px-1 py-1.5 text-start text-sm">
						<Avatar.Root class="size-8 rounded-lg">
							{#if photoURL}
								<Avatar.Image src={photoURL} alt={displayLabel} />
							{/if}
							<Avatar.Fallback class="rounded-lg">{initials}</Avatar.Fallback>
						</Avatar.Root>
						<div class="grid flex-1 text-start text-sm leading-tight">
							<span class="truncate font-medium">{displayLabel}</span>
							<span class="text-muted-foreground truncate text-xs">
								{email}
							</span>
						</div>
					</div>
				</DropdownMenu.Label>
				<DropdownMenu.Separator />
				<DropdownMenu.Group>
					<DropdownMenu.Item>
						<UserCircleIcon />
						Account
					</DropdownMenu.Item>
					<DropdownMenu.Item>
						<CreditCardIcon />
						Billing
					</DropdownMenu.Item>
					<DropdownMenu.Item>
						<NotificationIcon />
						Notifications
					</DropdownMenu.Item>
				</DropdownMenu.Group>
				<DropdownMenu.Separator />
				<DropdownMenu.Item variant="destructive" onclick={() => void firekitAuth.signOut()}>
					<LogoutIcon />
					Log out
				</DropdownMenu.Item>
			</DropdownMenu.Content>
		</DropdownMenu.Root>
	</Sidebar.MenuItem>
</Sidebar.Menu>
