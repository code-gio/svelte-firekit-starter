import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}

/**
 * Builds 1–2 character initials for avatars from display name or email.
 */
export function getUserInitials(
	displayName: string | null | undefined,
	email: string | null | undefined
): string {
	const name = displayName?.trim() ?? "";
	if (name.length > 0) {
		const parts = name.split(/\s+/).filter(Boolean);
		if (parts.length >= 2) {
			return (parts[0]![0]! + parts[1]![0]!).toUpperCase();
		}
		const word = parts[0] ?? name;
		const letters = word.slice(0, 2);
		return letters.toUpperCase();
	}

	const local = email?.trim().split("@")[0] ?? "";
	if (local.length >= 2) {
		return local.slice(0, 2).toUpperCase();
	}
	if (local.length === 1) {
		return local.toUpperCase();
	}
	return "?";
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type WithoutChild<T> = T extends { child?: any } ? Omit<T, "child"> : T;
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type WithoutChildren<T> = T extends { children?: any } ? Omit<T, "children"> : T;
export type WithoutChildrenOrChild<T> = WithoutChildren<WithoutChild<T>>;
export type WithElementRef<T, U extends HTMLElement = HTMLElement> = T & { ref?: U | null };
