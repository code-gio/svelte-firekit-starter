<script lang="ts">
	import PageHeader from '$lib/components/showcase/page-header.svelte';
	import DemoSection from '$lib/components/showcase/demo-section.svelte';
	import { Button } from '$lib/components/ui/button/index.js';
	import { Badge } from '$lib/components/ui/badge/index.js';
	import {
		firekitUploadTask,
		firekitDownloadUrl,
		firekitStorageList,
		deleteFile,
		firekitUser
	} from 'svelte-firekit';
	import { toast } from 'svelte-sonner';

	const storagePath = $derived(`firekit-demo/${firekitUser.uid}/uploads`);

	let fileInput: HTMLInputElement;
	let uploadTask = $state<ReturnType<typeof firekitUploadTask> | null>(null);
	let downloadPath = $state('');
	let downloadUrl = $derived(downloadPath ? firekitDownloadUrl(downloadPath) : null);

	const fileList = $derived(firekitStorageList(storagePath));

	function handleUpload() {
		const file = fileInput?.files?.[0];
		if (!file) {
			toast.error('Select a file first');
			return;
		}
		const path = `${storagePath}/${file.name}`;
		uploadTask = firekitUploadTask(path, file);
	}

	async function handleDelete(fullPath: string) {
		try {
			await deleteFile(fullPath);
			fileList.refresh();
			toast.success('File deleted');
		} catch (e: any) {
			toast.error(e.message);
		}
	}

	function viewDownloadUrl(fullPath: string) {
		downloadPath = fullPath;
	}
</script>

<PageHeader
	title="Storage"
	description="Upload files with progress tracking, get download URLs, and manage files in Firebase Storage."
/>

<div class="flex flex-col gap-6 px-4 lg:px-6">
	<DemoSection
		title="File Upload with Progress"
		description="firekitUploadTask() initiates a resumable upload with reactive progress tracking."
		code={`<script lang="ts">
  import { firekitUploadTask, firekitUser } from 'svelte-firekit';

  let fileInput: HTMLInputElement;

  function upload() {
    const file = fileInput.files[0];
    const path = 'firekit-demo/' + firekitUser.uid + '/uploads/' + file.name;

    const task = firekitUploadTask(path, file);

    // Reactive properties
    // task.progress    → 0-100
    // task.state       → 'running' | 'paused' | 'success' | 'error'
    // task.downloadURL → string | null (after success)

    // Control methods
    task.pause();
    task.resume();
    task.cancel();
  }
</script>

<input type="file" bind:this={fileInput} />
<button onclick={upload}>Upload</button>
<p>Progress: {task.progress}%</p>`}
	>
		<div class="space-y-4">
			<div class="flex gap-2">
				<input
					type="file"
					bind:this={fileInput}
					class="border-input flex-1 rounded-md border px-3 py-2 text-sm"
				/>
				<Button onclick={handleUpload}>Upload</Button>
			</div>

			{#if uploadTask}
				<div class="space-y-2">
					<div class="flex items-center gap-3">
						<Badge variant={uploadTask.state === 'success' ? 'default' : 'secondary'}>
							{uploadTask.state}
						</Badge>
						<span class="text-sm">{Math.round(uploadTask.progress)}%</span>
					</div>
					<div class="bg-muted h-2 w-full overflow-hidden rounded-full">
						<div
							class="bg-primary h-full rounded-full transition-all"
							style:width="{uploadTask.progress}%"
						></div>
					</div>
					{#if uploadTask.state === 'running'}
						<div class="flex gap-2">
							<Button variant="outline" size="sm" onclick={() => uploadTask?.pause()}>Pause</Button>
							<Button variant="destructive" size="sm" onclick={() => uploadTask?.cancel()}>Cancel</Button>
						</div>
					{:else if uploadTask.state === 'paused'}
						<Button variant="outline" size="sm" onclick={() => uploadTask?.resume()}>Resume</Button>
					{/if}
					{#if uploadTask.downloadURL}
						<div class="rounded-lg border p-3">
							<p class="text-muted-foreground text-xs">Download URL</p>
							<p class="mt-1 break-all text-sm">{uploadTask.downloadURL}</p>
						</div>
					{/if}
				</div>
			{/if}
		</div>
	</DemoSection>

	<DemoSection
		title="Download URL"
		description="firekitDownloadUrl() resolves a public download URL for a Storage path."
		code={`<script lang="ts">
  import { firekitDownloadUrl } from 'svelte-firekit';

  const download = firekitDownloadUrl('path/to/file.png');

  // download.url     → string | null
  // download.loading → boolean
  // download.error   → Error | null
</script>

{#if download.url}
  <img src={download.url} alt="Uploaded file" />
{/if}`}
	>
		{#if downloadUrl}
			<div class="space-y-2">
				{#if downloadUrl.loading}
					<p class="text-muted-foreground text-sm">Resolving URL...</p>
				{:else if downloadUrl.url}
					<div class="rounded-lg border p-3">
						<p class="text-muted-foreground text-xs">Resolved URL</p>
						<p class="mt-1 break-all text-sm">{downloadUrl.url}</p>
					</div>
				{:else if downloadUrl.error}
					<p class="text-sm text-red-500">{downloadUrl.error.message}</p>
				{/if}
			</div>
		{:else}
			<p class="text-muted-foreground text-sm">Select a file from the list below to view its download URL.</p>
		{/if}
	</DemoSection>

	<DemoSection
		title="Storage File Listing"
		description="firekitStorageList() lists files and subdirectories under a Storage path."
		code={`<script lang="ts">
  import { firekitStorageList, deleteFile } from 'svelte-firekit';

  const files = firekitStorageList('firekit-demo/USER_ID/uploads');

  // files.items    → { name, fullPath }[]
  // files.prefixes → { name }[] (subdirectories)
  // files.loading  → boolean

  // Delete a file
  await deleteFile('path/to/file.png');
  files.refresh();
</script>

{#each files.items as file}
  <p>{file.name}</p>
{/each}`}
	>
		<div class="space-y-4">
			<Button variant="outline" size="sm" onclick={() => fileList.refresh()}>Refresh List</Button>

			{#if fileList.loading}
				<p class="text-muted-foreground text-sm">Loading files...</p>
			{:else if !fileList.items || fileList.items.length === 0}
				<p class="text-muted-foreground text-sm">No files uploaded yet. Upload one above!</p>
			{:else}
				<div class="space-y-2">
					{#each fileList.items as file}
						<div class="flex items-center gap-3 rounded-lg border p-3">
							<span class="flex-1 text-sm">{file.name}</span>
							<Button variant="ghost" size="sm" onclick={() => viewDownloadUrl(file.fullPath)}>
								View URL
							</Button>
							<Button
								variant="ghost"
								size="sm"
								onclick={() => handleDelete(file.fullPath)}
							>
								Delete
							</Button>
						</div>
					{/each}
				</div>
			{/if}
		</div>
	</DemoSection>
</div>
