# ANU Events — Implementation Instructions

This document outlines practical, step-by-step checklists and guidance to complete Phase 1, Phase 2, and Phase 3 of the ANU Events mobile app. It's designed as a developer handbook to coordinate work, track progress, and keep releases predictable.

## How to use this doc
- Each Phase has a short goal, acceptance criteria, and a task checklist. Pick the next task, open a PR with clear scope, and attach screenshots or device logs for UI or platform work.
- For Firebase changes (indexes, security rules), include the emulator rules and a smoke test using the Firebase Emulator Suite.
- Keep PRs small and focused: one PR per user-visible feature or infra change.

---

## Phase 1 — MVP (goal: discovery, details, submit & moderation, saved reminders)

Acceptance criteria
- Discover and search events by keyword, category, date range, and distance
- Authenticated users can submit events and see pending status in their profile
- Moderators can approve/reject submissions and approved events become public
- Users can save events and receive scheduled push reminders (24h & 1h)
- Media uploads stored and served from Firebase Storage for approved images

Checklist (developer tasks)
- [ ] Scaffold and stabilize the app (CI checks, analyzer, tests)
- [x] Implement and test device/debug workflows (emulator and iOS device)
- [x] Vendor/plugin mitigation for `flutter_local_notifications` (temporary)
- [x] Saved events manager and scheduling abstraction
- [ ] Submit Event flow
  - [ ] 6-step UI (Basic, When, Where, Category, Poster, Review)
  - [ ] Draft save/load for authenticated users (`users/{uid}/drafts`)
  - [ ] Poster upload with progress and retry
  - [ ] Validation for required fields (title, startsAt, poster)
  - [ ] Submit writes `status: pending` and enforces server-side createdAt
  - [ ] Unit & widget tests for happy path and upload failure handling
- [ ] Moderator Queue & Admin UI
  - [ ] Pending list, approve/reject actions
  - [ ] Featured slot management
  - [ ] Audit logs for moderator actions
- [ ] Reminders & notifications
  - [ ] Implement platform NotificationService (Android/iOS) using plugin
  - [ ] Schedule 24h & 1h reminders on save
  - [ ] Tests for scheduling logic (unit tests)
- [ ] Firestore indexes and rules
  - [ ] Create composite indexes surfaced by queries
  - [ ] Emulator tests for security rules

Implementation notes & tips
- Keep server timestamps authoritative. Use `FieldValue.serverTimestamp()` where needed in Cloud Functions or when writing from trusted backends.
- Denormalize small snapshots on `events` for efficient feed queries (categoryName, posterThumb).
- Use geohash/bounding box for radius searches to avoid expensive queries.

---

## Phase 2 — Quality & polish (goal: search, filters, auth providers)

Acceptance criteria
- Google & Apple Sign-In enabled (iOS Apple Sign-In tested on device)
- Map view with radius search + filters implemented
- Submit flow improved: image processing, resizing, thumbnails
- Analytics: event views, saves, ticket clicks (sharded counters)

Checklist
- [ ] Google Sign-In, Apple Sign-In integration & e2e tests
- [ ] Map + search UI with filters (date, price, category, distance)
- [ ] Image processing pipeline (thumbnail generation in Cloud Functions)
- [ ] Analytics counters and dashboards

---

## Phase 3 — Release & distribution

Acceptance criteria
- Play Store and TestFlight beta builds ready
- CI pipelines produce debuggable artifacts for testers
- Moderator/admin back-office available

Checklist
- [ ] Create stores listings, policies, screenshots
- [ ] Create Play Console app and add service account with Release Manager
- [ ] Configure CI to build AAB and export symbols
- [ ] Run security & performance tests

---

## Quick dev workflows
- Local Firebase emulator run (recommended): `firebase emulators:start --only firestore,auth,storage`
- Run analyzer: `flutter analyze --no-pub`
- Run tests: `flutter test`

---

## Who to contact
- For infra/keys/playstore: Kenn
- For Cloud Functions / backend: Backend team lead
- For UI/UX clarifications: Design owner


If you'd like, I can also add a plain `docs/phase-checklist.json` that maps tasks to owners and PR links for reporting.