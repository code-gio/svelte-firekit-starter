<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import {
		ShaderMount,
		meshGradientFragmentShader,
		getShaderColorFromString,
		ShaderFitOptions,
		defaultObjectSizing,
		meshGradientMeta
	} from '@paper-design/shaders';
	import { CustomGuard, type UserProfile } from 'svelte-firekit';

	let { children: page } = $props();

	let containerEl: HTMLDivElement;

	const colors = ['#000000', '#8B4513', '#ffffff', '#3E2723', '#5D4037'];

	onMount(() => {
		if (!containerEl || typeof window === 'undefined') return;

		const fitValue =
			ShaderFitOptions[defaultObjectSizing.fit as keyof typeof ShaderFitOptions] ?? 1;
		const colorVec4s = colors.map((c) => getShaderColorFromString(c));
		while (colorVec4s.length < meshGradientMeta.maxColorCount) {
			colorVec4s.push([0, 0, 0, 0]);
		}

		const mount = new ShaderMount(
			containerEl,
			meshGradientFragmentShader,
			{
				u_imageAspectRatio: 1,
				u_originX: defaultObjectSizing.originX,
				u_originY: defaultObjectSizing.originY,
				u_worldWidth: defaultObjectSizing.worldWidth,
				u_worldHeight: defaultObjectSizing.worldHeight,
				u_fit: fitValue,
				u_scale: defaultObjectSizing.scale,
				u_rotation: defaultObjectSizing.rotation,
				u_offsetX: 0.08,
				u_offsetY: 0,
				u_colors: colorVec4s,
				u_colorsCount: colors.length,
				u_distortion: 1.2,
				u_swirl: 0.3,
				u_grainMixer: 0.2,
				u_grainOverlay: 0.1
			},
			undefined,
			0.3,
			0
		);

		return () => {
			mount.dispose();
		};
	});
</script>

<CustomGuard requireAuth={false} onUnauthorized={() => goto('/')}>
	{#snippet children(_user: UserProfile | null, _signOut: () => Promise<void>)}
		<div class="relative min-h-svh w-full overflow-hidden bg-black">
			<div bind:this={containerEl} class="fixed inset-0 w-full h-full" aria-hidden="true"></div>
			<div class="relative z-10 flex min-h-svh flex-col items-center justify-center gap-6 p-6 md:p-10">
				<div class="flex w-full max-w-sm flex-col gap-6">
					{@render page()}
				</div>
			</div>
		</div>
	{/snippet}
</CustomGuard>
