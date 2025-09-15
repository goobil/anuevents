# Phase 1 — MVP (4–6 weeks)

Goal: Build the minimal, high-quality mobile experience that enables discovery, event details, event submission with moderation, saved events and reminders, and the moderator/admin back-office.

Scope & Deliverables
- Home (Discover) feed with featured carousel and local feed
- Explore: map view with pins and list view + filters (date, category, distance, price)
- Event Details: poster, date/time, venue, tickets, organizer preview, share, save, report
- Submit Event flow: 6-step stepper with save-draft, media upload to Firebase Storage, validations
- Authentication: email/password + Google Sign-In + Apple Sign-In (iOS)
- Saved events & reminders (24h & 1h default)
- Moderator Queue: approve/reject/edit; admin console with featured slot management
- Firestore + Firebase Storage + Cloud Functions for background jobs
- Basic analytics: event views, saves, ticket clicks (sharded counters or safe increments)

MVP Acceptance Criteria
- Can discover and search events by keyword, category, date range, and distance
- Authenticated users can submit events and see pending status in their profile
- Moderators can approve/reject submissions and approved events become public
- Users can save events and receive push reminders at the specified times
- Media uploads stored and served from Firebase Storage with public read rules for approved images

Architecture & Implementation Notes
- Frontend: Flutter (single codebase for iOS & Android). Use Provider/riverpod or Bloc for state management.
- Backend: Firebase (Firestore, Storage, Auth, Cloud Functions, FCM)
- Use Firestore single `events` collection with `status` field for moderation (pending/approved/rejected)
- Denormalize small snapshots on `events` (categoryName, organizerName, venueName, posterThumb) for efficient lists
- Implement server-side slug mapping to ensure shareable and relatively stable URLs
- Use geofirex or geohash-based bounding box approach for radius queries

Milestones & Timeline (4–6 weeks)
1. Week 1: Project scaffold, Auth, Firestore basics, Home feed prototype
2. Week 2: Event details, bookmarks, basic search & filters
3. Week 3: Submit flow + media uploads + moderator queue
4. Week 4: Reminders, Cloud Functions (notifications, ranking), admin console
5. Week 5: QA, emulator test of security rules, soft launch to beta testers
6. Week 6: Buffer for bug fixes and performance tuning

Developer tasks (first sprint)
- Scaffold Flutter app and integrate Firebase packages
- Implement Auth flows and profile screen
- Build Firestore models and rules in emulator
- Implement Home feed (list + featured carousel) and Event detail screen
- Wire submit stepper UI and backend submission path

QA checklist (smoke tests)
- Create, submit, approve event flow
- Save event and receive 24h/1h reminder
- Map radius search returns expected results within X km
- Moderator cannot change protected fields via client

Notes
- Keep server timestamps authoritative for createdAt/updatedAt
- Use small poster thumbnails for feed lists to reduce bandwidth
- Start with coarse price tiers but add numeric price fields in schema for Phase 2