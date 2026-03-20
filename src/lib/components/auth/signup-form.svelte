<script lang="ts">
	import { cn } from "$lib/utils.js";
	import { Button } from "$lib/components/ui/button/index.js";
	import * as Card from "$lib/components/ui/card/index.js";
	import {
		FieldGroup,
		Field,
		FieldLabel,
		FieldDescription,
		FieldSeparator,
	} from "$lib/components/ui/field/index.js";
	import { Input } from "$lib/components/ui/input/index.js";
	import type { HTMLAttributes } from "svelte/elements";
	import { firekitAuth } from "svelte-firekit";
	import { goto } from "$app/navigation";
	import { toast } from "svelte-sonner";

	let { class: className, ...restProps }: HTMLAttributes<HTMLDivElement> = $props();

	let firstName = $state('');
	let lastName = $state('');
	let email = $state('');
	let password = $state('');
	let loading = $state(false);

	async function handleRegister(e: SubmitEvent) {
		e.preventDefault();
		loading = true;
		try {
			const displayName = [firstName, lastName].filter(Boolean).join(' ');
			await firekitAuth.registerWithEmail(email, password, displayName || undefined);
			goto('/');
		} catch (err: any) {
			toast.error(err?.message ?? 'Registration failed. Please try again.');
		} finally {
			loading = false;
		}
	}

	async function handleGoogleSignUp() {
		loading = true;
		try {
			await firekitAuth.signInWithGoogle();
			goto('/');
		} catch (err: any) {
			toast.error(err?.message ?? 'Google sign up failed. Please try again.');
		} finally {
			loading = false;
		}
	}
</script>

<div class={cn("flex flex-col gap-6", className)} {...restProps}>
	<Card.Root>
		<Card.Header class="text-center">
			<Card.Title class="text-xl">Create your account</Card.Title>
			<Card.Description>Sign up with Google, or enter your details below</Card.Description>
		</Card.Header>
		<Card.Content>
			<form onsubmit={handleRegister}>
				<FieldGroup>
					<Field>
						<Button variant="outline" type="button" onclick={handleGoogleSignUp} disabled={loading}>
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
								<path
									d="M12.48 10.92v3.28h7.84c-.24 1.84-.853 3.187-1.787 4.133-1.147 1.147-2.933 2.4-6.053 2.4-4.827 0-8.6-3.893-8.6-8.72s3.773-8.72 8.6-8.72c2.6 0 4.507 1.027 5.907 2.347l2.307-2.307C18.747 1.44 16.133 0 12.48 0 5.867 0 .307 5.387.307 12s5.56 12 12.173 12c3.573 0 6.267-1.173 8.373-3.36 2.16-2.16 2.84-5.213 2.84-7.667 0-.76-.053-1.467-.173-2.053H12.48z"
									fill="currentColor"
								/>
							</svg>
							Sign up with Google
						</Button>
					</Field>
					<FieldSeparator class="*:data-[slot=field-separator-content]:bg-card">
						Or continue with
					</FieldSeparator>
					<div class="grid grid-cols-2 gap-4">
						<Field>
							<FieldLabel for="first-name">First name</FieldLabel>
							<Input id="first-name" type="text" placeholder="John" required bind:value={firstName} />
						</Field>
						<Field>
							<FieldLabel for="last-name">Last name</FieldLabel>
							<Input id="last-name" type="text" placeholder="Doe" required bind:value={lastName} />
						</Field>
					</div>
					<Field>
						<FieldLabel for="email">Email</FieldLabel>
						<Input id="email" type="email" placeholder="m@example.com" required bind:value={email} />
					</Field>
					<Field>
						<FieldLabel for="password">Password</FieldLabel>
						<Input id="password" type="password" required bind:value={password} />
						<FieldDescription>Must be at least 8 characters long.</FieldDescription>
					</Field>
					<Field>
						<Button type="submit" disabled={loading}>Create Account</Button>
						<FieldDescription class="text-center">
							Already have an account? <a href="/sign-in" class="underline underline-offset-4 hover:no-underline">Sign in</a>
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
