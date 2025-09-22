
# Event App (2025) - New Layout Plan

**Goal:** Create the leading community-driven event discovery platform for
finding, submitting, and engaging with local and global events. Emphasize
meetups and track events (running, cycling, hiking), and travel-inspired
activities.

Focus the product on spontaneous meetups and authentic experiences for
travelers. The MVP leverages AI-assisted moderation, community networking,
and travel perks. Phase 2 introduces AI personalization, VIP subscriptions,
and monetization inspired by Eventbrite, ServiceNow, ASmallWorld, and
IslaGuru.

---

## 1) Personas & Roles

- **Guest:** Browse, search, and filter events. Guests are prompted to sign
  in for saves or submissions. AI-suggested event previews appear based on
  location or travel plans.
- **Member:** Submit events, bookmark, share, receive reminders, join meetup
  chats, and connect with attendees. Earn reputation points for hosting
  meetups or leaving reviews.
- **Organizer (verified):** Manage profiles, bulk upload events, access
  analytics, and use AI tools for promotion. Offer VIP benefits like
  priority listings or partner integrations.
- **Moderator:** Approve/deny submissions, edit content, and handle reports
  with AI assistance for spam detection and content scanning.
- **Admin:** Full control over feature slots, categories, roles, and audits;
  AI-driven dashboards for engagement trends.
- **Traveler Premium Member:** Paid tier with exclusive access to travel-
  focused events, VIP hotel deals, and an ad-free experience.

---

## 2) Core User Flows (MVP)

1. Discover → Details → Save/Share/Join Meetup

   Home feed → tap card → event details → save/share/open map/join in-app
   meetup chat. For travelers, AI suggests events based on location or trip
   itinerary (for example: "Top meetups in Barcelona this week").

2. Submit Event → AI Moderation → Publish

   Auth gate → form → upload poster/route (for track events) → submit →
   AI-assisted review (auto-flags incomplete or spam submissions) →
   publish.

3. Search & Filter with AI Recommendations

   Keyword + filters: date range, category, location radius, price, plus
   AI-driven suggestions.

4. Reminders

   Save event → push notifications 24h/1h before start; provide real-time
   updates for track events (weather alerts, live participant tracking).

---

## 3) Screen Wireframes (Text)

### 3.1 Home (Discover)

```text
[ AppBar  ◄Location ▼ ]   [🔔]
[ Search bar: "Find concerts, classes..." ]
[ Chips: All | Today | This Weekend | Free | Family | Music | Sports ]

— Featured (carousel) —
[▭ Large Card: Headline Event]

— Near You —
[▯ Event Card]  [▯ Event Card]
[▯ Event Card]  [▯ Event Card]

[ TabBar: Home • Explore • Submit • Saved • Profile ]
```

**Event Card:** Poster, title, date/time, venue, distance, price chip,
and a save icon.

### 3.2 Explore (Map + Filters)

```text
[ Map view with clustered pins ]
[ Filter drawer: date | category | distance | price | accessibility ]
```

### Deliverables Recap

- Wireframes (text) for MVP screens
- Firestore schema with collections, fields, indexes, and rules sketch
- Roadmap and metrics to guide rollout

> This package is designed so you can hand it to a developer and start
> sprint planning immediately.

- Monetization plan: featured placements, promo codes, partner promos
- Users/Roles: assign roles, verify organizers
- Settings: branding, regions, moderation policy, rate limits
- Audit Log: who did what and when

---

## 4) Firestore Data Model

Use Cloud Firestore with Firebase Storage for media. Collections are
organized per entity, with subcollections for ownership and history. The
model is denormalized where it helps read performance.

### 4.1 Collections & Fields

#### events (top-level)

- id (auto)
- title: string
- slug: string (unique, shareable URL)
- categoryId: ref → categories/{id}
- tagIds: string[]
- startAt, endAt: timestamp
- isAllDay: bool
- recurrence: object | null
- timezone: string (IANA)
- venueId: ref → venues/{id}
- location: geopoint
- isVirtual: bool
- virtualLink: string | null
- priceTier: 'free'|'$'|'$$'|'$$$'
- ticketUrl, posterUrl, galleryUrls
- trackRoute: object | null (e.g., { gpxUrl, distance })
- organizerId: ref → organizers/{id}
- status: 'pending'|'approved'|'rejected'|'archived'
- flags: { spam:boolean, nsfw:boolean, keywords:string[] }
- rankScore: number (AI-computed)
- createdBy, createdAt, updatedAt, approvedAt
- region: string

#### venues

- name, addressLine, city, region, country
- geo: geopoint
- placeId: string (optional)
- contact: { phone, email, website }
- accessibility: { wheelchair:boolean, parking:boolean, restroom:boolean }

#### categories

- name, slug, iconKey
- order: number
- active: bool

#### tags

- name, slug

#### organizers

- name, bio, avatarUrl
- links: { website, instagram, tiktok, youtube }
- verified: bool
- ownerUserId: ref → users/{id} (optional)

#### users

- displayName, photoURL, email
- role: 'member'|'organizer'|'moderator'|'admin'
- reputation: number
- prefs: { notifications:boolean, regions:string[] }
- createdAt

#### submissions (queue; optional if using `events.status` only)

- eventDraft: object (same shape as `events` but minimal)
- submittedBy: ref → users/{id}
- status: 'pending'|'approved'|'rejected'
- moderationNotes: string
- createdAt, updatedAt

#### bookmarks (per user)

- Path: users/{userId}/bookmarks/{eventId}
- Fields: createdAt

#### reports

- eventId, reportedBy, reason, details, createdAt, status

#### featuredSlots

- slotKey: 'home.hero'|'home.row1.1'|...
- eventId
- startsAt, endsAt
- priority: number

#### audits

- actorUserId, action, entity, entityId, diff, at

#### system (singleton doc like system/config)

- rateLimits: { submissionsPerMonth:number }
- regions: string[]

### 5.2 Indexing (Composite Examples)

- `events`:
  - `status + startAt` (for upcoming approved events)
  - `region + status + startAt` (regional feeds)
  - `categoryId + status + startAt`
  - `rankScore + status` (Top 10)

Geoqueries: Use `location` with a geo-utility (e.g., geofirex) to filter by
radius.

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

- onCreate(events): compute rankScore, run spam/keyword scans, notify
  moderators
- scheduled: archive past events, recompute rankings, run trend analysis
- moderation webhook: Slack/Email notif with Approve/Reject deep links
- push notifications: saved event reminders (24h / 1h)
- analytics aggregation: event views and saves counts (write to
  `events.metrics`)

---

## 6) Monetization Model

- Featured placements (CPC/flat): manages `featuredSlots` inventory.
- Organizer subscriptions: verified badge, analytics, bulk upload, auto-approval.
- Affiliate links: ticket partners; store `utm` params.

---

## 7) Success Metrics

- DAU/WAU, event view→save rate, save→attendance proxy (ticket clicks),
  submission-to-approval time, % approved, report rate.

---

## 8) Tech Stack Options

- Frontend: Flutter or React Native (single codebase, iOS/Android + web later).
- Backend: Firebase (Auth, Firestore, Storage, Cloud Functions, FCM, Hosting).
- Maps: Google Maps SDK (Android/iOS) or Apple Maps on iOS.
- Payments (later): Stripe for promoter subscriptions.
- CI/CD: Fastlane (mobile), GitHub Actions.

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

## 10) Sample Documents

### events/{id}

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

### users/{uid}/bookmarks/{eventId}

```json
{ "createdAt": "2025-07-28T12:11:00Z" }
```

---

## 11) Admin/Moderator UI Components (for Web Console)

- DataGrid views with server-side pagination and text search across `events`,
  `venues`, `organizers`.
- Bulk actions: approve, reject, feature, archive.
- CSV import wizard for organizers (maps columns → fields; shows validation
  errors).

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

- Prefer denormalization for read performance (store `category.name` snapshot
  on event for fast listing; keep background job to sync on category rename).
- Use server timestamps and FieldValue.increment for metrics to avoid race
  conditions.
- Keep search simple initially (title/desc/category/tags); add Algolia later
  for fuzzy search.
- For geo search, precompute geohash on write for fast bounding-box queries.

---

Ready for sprint planning and developer handoff.
    ````
