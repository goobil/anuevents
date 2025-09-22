# Cross-Platform Design & Engineering Guidance

Goal: Provide design and engineering guidance to ship a high-quality
cross-platform mobile app (iOS & Android) and later web.

Focus on Flutter as the primary frontend technology for consistent UI
and a single codebase.

Platform choice

- Flutter recommended for rapid feature parity across iOS & Android and a later pivot to Web.
- Use platform channels for deep OS integrations (Apple Maps on iOS, Google Maps on Android) where necessary.

UI/UX patterns

- Use Material 3 / Fluent-adjacent design tokens with platform-aware tweaks (e.g., back swipe on iOS).
- Design a small, reusable component library: EventCard, PosterImage, TagChip, FilterDrawer, MapPinView, StepperForm.
- Responsive layout for different screen sizes; test on low-end and high-end devices.

State Management

- Preferred: Riverpod (or Bloc if you want event sourcing style). Keep UI stateless where possible.
- Use an offline cache layer (Hive/SQLite) for saved events and basic feed caching to improve perceived performance.

Networking & Offline

- Use repository pattern with clear caching strategy: network-first for fresh feeds, cache-first for saved items.
- Use Firestore with local persistence enabled, but design a local fallback for initial app open without network.

Media & Storage

- Use Firebase Storage with structured folders: `organizers/{orgId}/posters/{eventId}.jpg` and `/thumbs/` for small sizes.
- Client-side image resizing and WebP conversion to save bandwidth. Use packages like `image` or platform-native utilities.

Maps & Geo

- Use platform maps SDKs for best UX. Use server-side geohash indexing for radius queries or geofire packages.
- Provide list view fallback for accessibility and offline mode.

Auth & Security

- Support OAuth providers (Google, Apple) and email sign-in. Use Firebase Auth custom claims for roles.
- Keep security-critical operations behind callable Cloud Functions (e.g., approve event, purchase slot).

Testing & CI

- Use widget/unit tests (Flutter) for UI and logic. Use Firebase emulator for integration tests of rules and functions.
- CI: GitHub Actions for builds and test runs, Fastlane for release automation.

Performance

- Lazy-load images with placeholders and shimmer effects. Preload thumbnails for lists.
- Use pagination with cursor-based queries for feeds.

Accessibility

- Ensure semantic labels for images and buttons
- Map interactions accessible in list mode
- Support dynamic type/large font sizes and dark mode

Developer Experience

- Maintain an internal `design-tokens.dart` with colors, typography, and spacing
- Provide storybook-like component previews (e.g., using `dashbook` or custom dev routes)

Platform-specific notes

- iOS: prefer Apple Maps if using map native UI, support Sign in with Apple
- Android: Google Maps, background permissions for location when needed

Design Handoff

- Provide Figma file with tokens, components, and annotated flows for each screen
- Export assets for 1x/2x/3x densities and WebP thumbnails

Next steps

- Create a minimal component library and start implementing Phase 1 UI screens
- Add security rules and emulator tests for basic CRUD
- Prepare CI pipeline to run tests and build artifacts for QA

Appendix: quick checklist

- Component library scaffolded
- Firebase project + emulator configured
- Basic CI pipeline with unit and integration tests
- Design tokens and Figma link in project README
