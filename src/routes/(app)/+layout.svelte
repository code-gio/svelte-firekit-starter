<script lang="ts">
  import * as Sidebar from "$lib/components/ui/sidebar/index.js";
  import AppSidebar from "$lib/components/layout/app-sidebar.svelte";
  import SiteHeader from "$lib/components/auth/site-header.svelte";
  import { AuthGuard } from "svelte-firekit";
  import { goto } from "$app/navigation";
  let { children } = $props();
</script>

<AuthGuard requireAuth={true} onUnauthorized={() => goto("/sign-in")}>
  <Sidebar.Provider
    style="--sidebar-width: calc(var(--spacing) * 72); --header-height: calc(var(--spacing) * 12);"
  >
    <AppSidebar variant="inset" />
    <Sidebar.Inset>
      <SiteHeader />
      <div class="flex flex-1 flex-col">
        <div class="@container/main flex flex-1 flex-col gap-2">
          <div class="flex flex-col gap-4 py-4 md:gap-6 md:py-6">
            {@render children()}
          </div>
        </div>
      </div>
    </Sidebar.Inset>
  </Sidebar.Provider>
</AuthGuard>
