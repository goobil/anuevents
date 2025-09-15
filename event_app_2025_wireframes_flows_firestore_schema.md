# Event App (2025)

**Goal:** A community-driven event discovery platform where users can find, submit, and engage with local events. MVP focuses on curated listings with admin moderation; Phase 2 adds social/community features and monetization.

---

## 1) Personas & Roles
- **Guest:** Browse, search, filter; prompted to sign in for saves/submissions.
- **Member:** Submit events, bookmark, share, receive reminders.
- **Organizer (verified):** Manage organizer profile, bulk upload, analytics.
- **Moderator:** Approve/deny submissions, edit content, handle reports.
- **Admin:** Full control, feature slots, categories, roles, audits.

---

## 2) Core User Flows (MVP)
1. **Discover → Details → Save/Share**  
   Home feed → tap card → event details → save/share/open map.
2. **Submit Event → Moderation → Publish**  
   Auth gate → form → upload poster → submit → pending review → publish.
3. **Search & Filter**  
   Keyword + filters: date range, category, location radius, price (free/paid).
4. **Reminders**  
   Save event → push notification 24h & 1h before start.

---

## 3) Screen Wireframes (Text)

### 3.1 Home (Discover)
```
[ AppBar  ◄Location ▼ ]   [🔔]
[ Search bar: "Find concerts, classes..." ]
[ Chips: All | Today | This Weekend | Free | Family | Music | Sports | ... ]

— Featured (carousel) —
[▭ Large Card: Headline Event]

— Near You —  (grid/list)
[▯ Event Card]  [▯ Event Card]
[▯ Event Card]  [▯ Event Card]

[ TabBar: Home • Explore • Submit • Saved • Profile ]
```
**Event Card**: Poster, title, date/time, venue, distance, price chip ("Free"), save icon.

### 3.2 Explore (Map + Filters)
```
[ Search + Filter icon ]
--------------------------------
|          Map with pins        |
|  ⊙ user                       |
--------------------------------
[List of results sorted by date/distance]
```
**Filters Drawer**: Date range picker, Category multi-select, Distance slider, Price (Free, <$25, $$), Accessibility tags.

### 3.3 Event Details
```
[Poster]
[Title]
[Date & Time]  [Add to Calendar]
[Venue + map thumbnail → Open Maps]
[Price/Tickets → External Link]
[Description]
[Organizer chip → Organizer profile]
[Share] [Save] [Report]
[Similar events]
```

### 3.4 Submit Event (Auth Gate)
```
[Stepper]
1. Basics: Title, Category, Tags, Short description (140), Full description
2. When: Start, End, Timezone, Recurrence (None/Weekly/Monthly)
3. Where: Venue name, Address, Geo (auto geocode), Virtual? Join link
4. Media: Poster (required), Gallery (3), Video link
5. Tickets: Free? Price, Currency, External ticket URL
6. Review + Submit

[Submit] → status: Pending Review
```
Validation: required fields, image size, future dates, spam guard.

### 3.5 Saved
List of user bookmarks, segmented by upcoming/past; quick toggle to notifications.

### 3.6 Profile
- Avatar, display name, bio.
- Tabs: Submitted • Saved • Settings.
- Settings: Notification preferences, connected accounts, delete account.

### 3.7 Moderator Queue
```
[ Tabs: Pending | Approved | Rejected | Reported ]
[ Filters: Category, Date, Location, Submitter reputation ]
Row: Poster • Title • Start • Venue • Flags • [Approve] [Edit] [Reject]
```
**Edit Sheet**: quick fixes to title, description, category, tags, time, venue.

### 3.8 Admin Console
- **Overview:** Submissions today, approvals, reports, featured slots performance.
- **Content:** Events, Venues, Categories, Tags, Organizers.
- **Monetization:** Featured placements (schedule, inventory), promo codes.
- **Users/Roles:** Assign roles, verify organizers.
- **Settings:** Branding, regions, moderation policy, rate limits.
- **Audit Log:** Who did what, when.

---

## 4) Information Architecture
- **Spaces**: Public app (Home/Explore/Details), Member space (Saved/Submit), Backoffice (Moderator/Admin).
- **Taxonomy**: Categories (Music, Sports, Family, Business...), free-form Tags.
- **Geography**: Country → City/Parish; venues store lat/lng for radius queries.

---

## 5) Firestore Data Model (Recommended)
> Use **Cloud Firestore** (with Firebase Storage for media). Prefer collection-per-entity with subcollections where ownership/history is needed.

### 5.1 Collections & Fields

**`events`** (top-level)
- `id` (auto)
- `title`: string
- `slug`: string (unique, for shareable URLs)
- `categoryId`: ref → `categories/{id}`
- `tagIds`: string[] (denormalized tag ids)
- `startAt`: timestamp
- `endAt`: timestamp
- `isAllDay`: bool
- `recurrence`: object | null  
  `{ type: 'none'|'weekly'|'monthly', interval: number, byWeekday?: number[] }`
- `timezone`: string (IANA)
- `venueId`: ref → `venues/{id}`
- `location`: geopoint (for distance queries)
- `isVirtual`: bool
- `virtualLink`: string | null
- `priceTier`: 'free'|'$'|'$$'|'$$$'
- `ticketUrl`: string | null
- `posterUrl`: string
- `galleryUrls`: string[]
- `organizerId`: ref → `organizers/{id}`
- `status`: 'pending'|'approved'|'rejected'|'archived'
- `flags`: { spam:boolean, nsfw:boolean, keywords:string[] }
- `rankScore`: number (for Top 10)
- `createdBy`: ref → `users/{id}`
- `createdAt`: timestamp
- `updatedAt`: timestamp
- `approvedAt`: timestamp | null
- `region`: string (for multi-region feeds)

**`venues`**
- `name`, `addressLine`, `city`, `region`, `country`
- `geo`: geopoint
- `placeId`: string (optional, Google/Apple)
- `contact`: { phone, email, website }
- `accessibility`: { wheelchair:boolean, parking:boolean, restroom:boolean }

**`categories`**
- `name`, `slug`, `iconKey`
- `order`: number (for UI chips)
- `active`: bool

**`tags`**
- `name`, `slug`

**`organizers`**
- `name`, `bio`, `avatarUrl`
- `links`: { website, instagram, tiktok, youtube }
- `verified`: bool
- `ownerUserId`: ref → `users/{id}` (optional)

**`users`**
- `displayName`, `photoURL`, `email`
- `role`: 'member'|'organizer'|'moderator'|'admin'
- `reputation`: number
- `prefs`: { notifications:boolean, regions:string[] }
- `createdAt`

**`submissions`** (queue; optional if using `events.status` only)
- `eventDraft`: object (same shape as `events` but minimal)
- `submittedBy`: ref → `users/{id}`
- `status`: 'pending'|'approved'|'rejected'
- `moderationNotes`: string
- `createdAt`, `updatedAt`

**`bookmarks`** (per user)
- Path: `users/{userId}/bookmarks/{eventId}`
- Fields: `createdAt`

**`reports`**
- `eventId`, `reportedBy`, `reason`, `details`, `createdAt`, `status`

**`featuredSlots`**
- `slotKey`: 'home.hero'|'home.row1.1'|...
- `eventId`
- `startsAt`, `endsAt`
- `priority`: number

**`audits`**
- `actorUserId`, `action`, `entity`, `entityId`, `diff`, `at`

**`system`** (singleton doc like `system/config`)
- `rateLimits`: { submissionsPerMonth:number }
- `regions`: string[]

### 5.2 Indexing (Composite Examples)
- `events`:
  - `status + startAt` (for upcoming approved events)
  - `region + status + startAt` (regional feeds)
  - `categoryId + status + startAt`
  - `rankScore + status` (Top 10)
- Geoqueries: Use `location` with a geo-utility (e.g., geofirex/own bounds) to filter by radius.

### 5.3 Security Rules (Sketch)
```javascript
match /databases/{db}/documents {
  function isSignedIn() { return request.auth != null; }
  function isRole(r) { return isSignedIn() && request.auth.token.role == r; }
  function hasAnyRole(arr) { return isSignedIn() && arr.hasAny([request.auth.token.role]); }

  // Public reads for approved events only
  match /events/{id} {
    allow read: if resource.data.status == 'approved';
    allow create: if isSignedIn();
    allow update, delete: if hasAnyRole(['moderator','admin']);
  }

  // User-owned subcollections
  match /users/{uid}/bookmarks/{eventId} {
    allow read, write: if isSignedIn() && request.auth.uid == uid;
  }

  // Admin-only collections
  match /featuredSlots/{id} {
    allow read: if true; // public can read to render
    allow write: if hasAnyRole(['admin']);
  }
}
```

### 5.4 Cloud Functions
- **onCreate(`events`)**: compute `rankScore`, spam/keyword scan, notify moderators.
- **scheduled:** daily cleanup (archive past events > X days), recompute rankings.
- **moderation webhook:** Slack/Email notif with Approve/Reject deep links.
- **push notifications:** when a saved event is 24h/1h away.
- **analytics aggregation:** event views/saves counts (write to `events.metrics`).

---

## 6) Monetization Model (Optional)
- **Featured placements** (CPC/flat): manages `featuredSlots` inventory.
- **Organizer subscriptions:** verified badge, analytics, bulk upload, auto-approval.
- **Affiliate links:** ticket partners; store `utm` params.

---

## 7) Success Metrics
- DAU/WAU, event view→save rate, save→attendance proxy (ticket clicks), submission-to-approval time, % approved, report rate.

---

## 8) Tech Stack Options
- **Frontend:** Flutter or React Native (single codebase, iOS/Android + web later).
- **Backend:** Firebase (Auth, Firestore, Storage, Cloud Functions, FCM, Hosting for web console).
- **Maps:** Google Maps SDK (Android/iOS) or Apple Maps on iOS.
- **Payments (later):** Stripe for promoter subscriptions.
- **CI/CD:** Fastlane (mobile), GitHub Actions.

---

## 9) Roadmap
**MVP (4–6 weeks):**
- Home/Explore + search & filters
- Event details
- Auth + submit flow
- Moderator queue + approval
- Saved events + notifications

**Phase 2:**
- Organizer profiles & bulk import
- Featured slots & monetization
- Reviews/ratings
- Multi-region support

**Phase 3:**
- Social graph (follow friends/organizers)
- Recommendation feed
- Web app

---

## Implementation phases
This document is the canonical product spec. Implementation is split into discrete phases with developer-facing guides and checklists:

- Phase 1 — MVP: core discovery, submit & moderation, saved events, reminders. See `docs/phase-1-mvp.md` for milestones, acceptance criteria, and developer tasks.
- Phase 2 — Organizer Tools & Monetization: organizer profiles, bulk import, featured slots, billing. See `docs/phase-2-organizer-monetization.md` for details.
- Phase 3 — Scale, Social & Web: web presence, social features, recommendations, search scaling. See `docs/phase-3-scale-social-web.md`.
- Cross-platform design & engineering guidance: implementation patterns, Flutter recommendations, component library, CI, and QA checklist: `docs/cross-platform-design.md`.

Link these documents into sprint planning and keep this file as the high-level product spec.

---

## 10) Sample Documents
**events/{id}**
```json
{
  "title": "Sunset Jazz on the Harbor",
  "categoryId": "music",
  "tagIds": ["live", "outdoor"],
  "startAt": "2025-08-02T18:00:00Z",
  "endAt": "2025-08-02T21:00:00Z",
  "venueId": "v_theharbor",
  "location": { "_lat": 17.121, "_long": -61.846 },
  "isVirtual": false,
  "priceTier": "$",
  "ticketUrl": "https://ticket.example/jazz",
  "posterUrl": "gs://bucket/events/jazz.jpg",
  "organizerId": "org_culturalboard",
  "status": "approved",
  "rankScore": 0.87,
  "region": "ATG"
}
```

**users/{uid}/bookmarks/{eventId}**
```json
{ "createdAt": "2025-07-28T12:11:00Z" }
```

---

## 11) Admin/Moderator UI Components (for Web Console)
- DataGrid views with server-side pagination and text search across `events`, `venues`, `organizers`.
- Bulk actions: approve, reject, feature, archive.
- CSV import wizard for organizers (maps columns → fields; shows validation errors).

---

## 12) Testing & Quality
- Unit tests for form validation and ranking function.
- Integration tests for submission→approval→publish.
- Device testing matrix (low-end Android to latest iPhone).

---

## 13) Privacy & Safety
- PII minimal; avoid storing exact attendee lists.
- Content policy & reporting flow; rate-limit by IP+account.
- Media scanning for unsafe content (Cloud Vision/Nudity heuristics) on upload.

---

## 14) Implementation Notes & Tips
- Prefer **denormalization** for read performance (store `category.name` snapshot on event for fast listing; keep background job to sync on category rename).
- Use **server timestamps** and **FieldValue.increment** for metrics to avoid race conditions.
- Keep **search** simple initially (title/desc/category/tags); add Algolia/Meilisearch later for fuzzy.
- For geo search, precompute **geohash** on write for fast bounding-box queries.

---

### Deliverables Recap
- Wireframes (text) for MVP screens
- Firestore schema with collections, fields, indexes, rules sketch
- Roadmap and metrics to guide rollout

> This package is designed so you can hand it to a developer and start sprint planning immediately.

