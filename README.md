# Svelte Firekit Starter

A production-ready starter template for building Firebase-powered applications with [SvelteKit](https://svelte.dev/) and [svelte-firekit](https://sveltefirekit.com). Includes interactive demos for every Firekit feature, authentication flows, and a polished UI built with shadcn-svelte.

## Features

- **Svelte 5** with runes-based reactivity
- **SvelteKit** file-based routing with layout groups
- **Firebase** authentication, Firestore, Realtime Database, and Storage
- **svelte-firekit** reactive wrappers for all Firebase services
- **shadcn-svelte** component library with 30+ UI components
- **Tailwind CSS v4** for styling
- **TypeScript** throughout
- **Dark mode** support via mode-watcher
- **Form handling** with sveltekit-superforms and Valibot/Zod validation

## Demo Pages

The starter includes 7 interactive demo pages showcasing Firekit features:

| Page | Route | Description |
| --- | --- | --- |
| Overview | `/` | User state dashboard and feature index |
| Authentication | `/auth` | User profile, SignedIn/SignedOut components |
| Documents | `/documents` | Real-time Firestore document subscriptions |
| Collections | `/collections` | Collection queries with reactive updates |
| Mutations | `/mutations` | CRUD operations, counters, field helpers |
| Realtime DB | `/realtime` | Realtime Database nodes and lists |
| Storage | `/storage` | File uploads with progress tracking |
| Presence | `/presence` | Network status and offline detection |

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18+)
- A [Firebase](https://console.firebase.google.com/) project with the following services enabled:
  - Authentication (Email/Password and Google sign-in providers)
  - Cloud Firestore
  - Realtime Database
  - Storage

### Installation

1. Clone the repository:

```bash
git clone https://github.com/code-gio/svelte-firekit-starter.git
cd svelte-firekit-starter
```

2. Install dependencies:

```bash
npm install
```

3. Configure Firebase by copying `.env.example` to `.env` and filling in your Firebase project credentials:

```bash
cp .env.example .env
```

```env
PUBLIC_FIREBASE_API_KEY=your-api-key
PUBLIC_FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
PUBLIC_FIREBASE_DATABASE_URL=https://your-project.firebaseio.com
PUBLIC_FIREBASE_PROJECT_ID=your-project-id
PUBLIC_FIREBASE_STORAGE_BUCKET=your-project.firebasestorage.app
PUBLIC_FIREBASE_MESSAGING_SENDER_ID=your-sender-id
PUBLIC_FIREBASE_APP_ID=your-app-id
PUBLIC_FIREBASE_MEASUREMENT_ID=G-XXXXXXXXXX
```

4. Start the development server:

```bash
npm run dev
```

## Project Structure

```
src/
├── lib/
│   ├── components/
│   │   ├── ui/            # shadcn-svelte components (button, card, sidebar, etc.)
│   │   ├── auth/          # Auth forms (sign-in, sign-up, forgot-password)
│   │   ├── layout/        # App sidebar, navigation, user menu
│   │   └── showcase/      # Demo page utilities (code blocks, sections)
│   ├── hooks/             # Svelte hooks (is-mobile)
│   ├── assets/            # Static assets (favicon)
│   ├── firebase.ts        # Firebase app initialization
│   └── utils.ts           # Utility functions (cn, getUserInitials)
├── routes/
│   ├── (auth)/            # Public auth routes (sign-in, sign-up, forgot-password)
│   └── (app)/             # Protected routes behind AuthGuard
│       ├── +page.svelte          # Overview
│       ├── auth/+page.svelte     # Authentication demo
│       ├── documents/+page.svelte # Firestore documents demo
│       ├── collections/+page.svelte # Collections demo
│       ├── mutations/+page.svelte   # CRUD demo
│       ├── realtime/+page.svelte    # Realtime DB demo
│       ├── storage/+page.svelte     # Storage demo
│       └── presence/+page.svelte    # Presence demo
└── app.d.ts               # TypeScript type definitions
```

## Removing Demo Data

Run the included script to strip all demo content and get a clean starting point:

```bash
bash scripts/remove-demo.sh
```

This script will:

- Remove all demo route pages (`/auth`, `/documents`, `/collections`, `/mutations`, `/realtime`, `/storage`, `/presence`)
- Remove showcase components (`demo-section`, `page-header`, `code-block`)
- Replace the overview page with a clean starter
- Reset the sidebar navigation to a single "Home" link

The script **preserves** the auth service pages (`/sign-in`, `/sign-up`, `/forgot-password`), the app layout with `AuthGuard`, and all UI components.

### Clean up Firebase demo data

The demo pages store data under the `firekit-demo` path, scoped per user:

- **Firestore**: `firekit-demo/{userId}/profile`, `firekit-demo/{userId}/todos`, `firekit-demo/{userId}/counters/demo`
- **Realtime Database**: `firekit-demo/{userId}/counter`, `firekit-demo/{userId}/messages`
- **Storage**: `firekit-demo/{userId}/uploads/`

To delete this data from your Firebase project:

- **Firestore**: In the [Firebase Console](https://console.firebase.google.com/), go to Firestore Database and delete the `firekit-demo` collection
- **Realtime Database**: Navigate to Realtime Database and delete the `firekit-demo` node
- **Storage**: Go to Storage and delete the `firekit-demo` folder

### Update Firestore security rules (optional)

If you had set up rules for the demo paths, remove them and add rules for your own collections.

## Scripts

| Command | Description |
| --- | --- |
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm run preview` | Preview production build |
| `npm run check` | Run svelte-check for type errors |
| `npm run check:watch` | Run svelte-check in watch mode |

## Tech Stack

| Category | Technology |
| --- | --- |
| Framework | [SvelteKit](https://svelte.dev/) v2 + [Svelte](https://svelte.dev/) v5 |
| Backend | [Firebase](https://firebase.google.com/) v12 |
| Firebase SDK | [svelte-firekit](https://sveltefirekit.com) |
| UI Components | [shadcn-svelte](https://www.shadcn-svelte.com/) |
| Styling | [Tailwind CSS](https://tailwindcss.com/) v4 |
| Icons | [Tabler Icons](https://tabler.io/icons) + [Lucide](https://lucide.dev/) |
| Forms | [sveltekit-superforms](https://superforms.rocks/) |
| Validation | [Valibot](https://valibot.dev/) / [Zod](https://zod.dev/) |

## License

MIT
