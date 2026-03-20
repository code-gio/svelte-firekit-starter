<script lang="ts">
	import { Button } from "$lib/components/ui/button/index.js";
	import * as Card from "$lib/components/ui/card/index.js";
	import {
		FieldGroup,
		Field,
		FieldLabel,
		FieldDescription,
	} from "$lib/components/ui/field/index.js";
	import { Input } from "$lib/components/ui/input/index.js";
	import { cn } from "$lib/utils.js";
	import type { HTMLAttributes } from "svelte/elements";
	import { firekitAuth } from "svelte-firekit";
	import { toast } from "svelte-sonner";

	let { class: className, ...restProps }: HTMLAttributes<HTMLDivElement> = $props();

	const id = "forgot-password";
	let email = $state('');
	let loading = $state(false);

	async function handlePasswordReset(e: SubmitEvent) {
		e.preventDefault();
		loading = true;
		try {
			await firekitAuth.sendPasswordReset(email);
			toast.success('Password reset email sent. Check your inbox.');
			email = '';
		} catch (err: any) {
			toast.error(err?.message ?? 'Failed to send reset email. Please try again.');
		} finally {
			loading = false;
		}
	}
</script>

<div class={cn("flex flex-col gap-6", className)} {...restProps}>
	<Card.Root>
		<Card.Header class="text-center">
			<Card.Title class="text-xl">Forgot password</Card.Title>
			<Card.Description>
				Enter your email and we'll send you a link to reset your password.
			</Card.Description>
		</Card.Header>
		<Card.Content>
			<form onsubmit={handlePasswordReset}>
				<FieldGroup>
					<Field>
						<FieldLabel for="email-{id}">Email</FieldLabel>
						<Input id="email-{id}" type="email" placeholder="m@example.com" required bind:value={email} />
					</Field>
					<Field>
						<Button type="submit" disabled={loading}>Send reset link</Button>
						<FieldDescription class="text-center">
							Remember your password? <a href="/sign-in" class="underline underline-offset-4 hover:no-underline">Sign in</a>
						</FieldDescription>
					</Field>
				</FieldGroup>
			</form>
		</Card.Content>
	</Card.Root>
	<FieldDescription class="px-6 text-center">
		By clicking continue, you agree to our <a href="/terms-of-service" class="underline underline-offset-4 hover:no-underline">Terms of Service</a>
		and <a href="/privacy-policy" class="underline underline-offset-4 hover:no-underline">Privacy Policy</a>.
	</FieldDescription>
</div>
