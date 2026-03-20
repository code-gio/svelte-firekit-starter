<script lang="ts">
  import "./layout.css";
  import favicon from "$lib/assets/favicon.svg";
  import { Toaster } from "$lib/components/ui/sonner/index.js";
  import { ModeWatcher } from "mode-watcher";
  import { firebaseConfig } from "$lib/firebase";
  import { FirebaseApp } from "svelte-firekit";
  let { children } = $props();
</script>

<Toaster />
<ModeWatcher />
<svelte:head><link rel="icon" href={favicon} /></svelte:head>
<FirebaseApp config={firebaseConfig}>
  {@render children()}
</FirebaseApp>