# Event App (2025) - New Layout Plan

**Goal:** Create the leading community-driven event discovery platform for finding, submitting, and engaging with local and global events, emphasizing meetups, track events (e.g., running, cycling, hiking), and travel-inspired activities. Designed to excel as the go-to app for spontaneous meetups and authentic experiences, especially for travelers seeking fun activities in foreign countries. The MVP leverages AI-assisted moderation, community networking, and travel perks, with Phase 2 introducing advanced AI personalization, VIP subscriptions, and monetization inspired by Eventbrite (ticketing and discovery), ServiceNow (AI workflows), ASmallWorld (luxury community and VIP perks), and IslaGuru (destination guides).

---

## 1) Personas & Roles
- **Guest:** Browse, search, filter; prompted to sign in for saves or submissions. AI-suggested event previews based on location or travel plans (ServiceNow-inspired real-time personalization).
- **Member:** Submit events, bookmark, share, receive reminders, join meetup chats, and connect with attendees. Earn reputation points for hosting meetups or leaving reviews (ASmallWorld-style community engagement).
- **Organizer (verified):** Manage profiles, bulk upload events, access analytics, and use AI tools for promotion (e.g., attendee matching). Offer VIP benefits like priority listings or partner integrations (Eventbrite and ASmallWorld influence).
- **Moderator:** Approve/deny submissions, edit content, handle reports with AI assistance for spam detection and content scanning (ServiceNow’s AI risk management).
- **Admin:** Full control over feature slots, categories, roles, and audits; AI-driven dashboards for engagement trends (ServiceNow analytics).
- **Traveler Premium Member:** Paid tier with exclusive access to travel-focused events, VIP hotel deals, airline tier upgrades, and ad-free experience (ASmallWorld Prestige model).

---

## 2) Core User Flows (MVP)
1. **Discover → Details → Save/Share/Join Meetup**  
   Home feed → tap card → event details → save/share/open map/join in-app meetup chat. For travelers, AI suggests events based on detected location or trip itinerary (e.g., "Top meetups in Barcelona this week").
2. **Submit Event → AI Moderation → Publish**  
   Auth gate → form → upload poster/route (for track events) → submit → AI-assisted review (auto-flags incomplete/spam submissions) → publish. Supports track event specifics like GPX route uploads (Eventbrite-inspired creation).
3. **Search & Filter with AI Recommendations**  
   Keyword + filters: date range, category, location radius, price, plus AI-driven suggestions (e.g., "Based on your running meetups" via ServiceNow-like AI agents). Traveler mode: Filter by "solo-friendly," "English-speaking," or "cultural immersion" tags (IslaGuru influence).
4. **Reminders & Live Updates**  
   Save event → push notifications 24h/1h before start; real-time updates for track events (e.g., weather alerts, live participant tracking). Community alerts for last-minute meetups.
5. **Community Connection Flow**  
   Post-event: Rate, review, connect with attendees via profiles or follow features (ASmallWorld networking). Join event-based group chats for ongoing interaction.
6. **Travel Discovery Flow**  
   Input destination → AI-curated event lists, destination guides, and partner perks (e.g., hotel discounts, inspired by IslaGuru and ASmallWorld). Integrated ticketing for seamless booking (Eventbrite model).

---

## 3) Screen Wireframes (Text)

### 3.1 Home (Discover)
```
[ AppBar  ◄Location ▼ ]   [🔔]   [AI Chat Icon]
[ Search bar: "Find meetups, track events, or travel adventures..." ]
[ Chips: All | Today | This Weekend | Free | Family | Music | Sports | Travel | Meetups | Track Events | ... ]

— Featured (AI-personalized carousel) —
[▭ Large Card: Headline Event or Traveler Pick (e.g., "Top Meetups in Paris")]

— Near You / For Travelers —  (grid/list with AI sorting)
[▯ Event Card]  [▯ Event Card]
[▯ Event Card]  [▯ Event Card]

[ TabBar: Home • Explore • Submit • Saved • Community • Profile ]
```
**Event Card**: Poster, title, date/time, venue, distance, price chip ("Free"), save icon, attendee count, "Join Meetup" button, "Traveler-Friendly" badge.

### 3.2 Explore (Map + Filters + AI Guides)
```
[ Search + Filter icon + AI Suggest ]
--------------------------------
| Map with pins & routes (track events) |
| ⊙ user   [Overlay: AI Travel Guide Snippet] |
--------------------------------
[List of results sorted by date/distance/relevance]
```
**Filters Drawer**: Date range, Category multi-select (add "Meetups," "Track Events"), Distance slider, Price (Free, <$25, $$), Accessibility tags, Traveler filters (e.g., language, group size). AI chat for personalized recommendations (ServiceNow-inspired).

### 3.3 Event Details
```
[Poster or Interactive Track Route Map]
[Title]
[Date & Time]  [Add to Calendar]  [Live Track Route (if applicable)]
[Venue + map thumbnail → Open Maps]
[Price/Tickets → Integrated Ticketing]
[Description + AI-Generated Summary]
[Organizer chip → Organizer profile]
[Share] [Save] [Report] [Join Chat/Meetup]
[Similar events + AI Recommendations]
[Traveler Perks: Hotel Deals/Airline Upgrades]
[Post-Event Reviews & Connections]
```

### 3.4 Submit Event (Auth Gate with AI Assistance)
```
[Stepper with AI Auto-Fill Suggestions]
1. Basics: Title, Category (auto-suggest), Tags, Short description (140), Full description (AI grammar check)
2. When: Start, End, Timezone, Recurrence; AI conflict checker
3. Where: Venue name, Address, Geo (auto geocode), Virtual? Join link; Track route upload (GPX support)
4. Media: Poster (required), Gallery (3), Video link; AI content scan
5. Tickets: Free? Price, Currency, Integrated ticketing (Eventbrite-style)
6. Traveler Features: Language options, Cultural notes (IslaGuru guides)
7. Review + Submit

[Submit] → status: Pending AI/Moderator Review
```

### 3.5 Saved & Community
- **Saved**: Bookmarks segmented by upcoming/past; toggle notifications and meetup RSVPs.
- **Community Tab**: Forums, member profiles, event-based groups; connect for future meetups (ASmallWorld community focus).

### 3.6 Profile
- Avatar, display name, bio, travel history badge (e.g., "Visited 10 cities").
- Tabs: Submitted • Saved • Connections • Settings.
- Settings: Notification preferences, connected accounts (e.g., airlines/hotels), delete account. Reputation score and badges (e.g., "Top Meetup Host").

### 3.7 Moderator Queue
```
[ Tabs: Pending | Approved | Rejected | Reported ]
[ Filters: Category, Date, Location, Submitter reputation ]
Row: Poster • Title • Start • Venue • Flags • [Approve] [Edit] [Reject] • AI Insights
```
**Edit Sheet**: Quick fixes; AI suggestions for content improvements.

### 3.8 Admin Console
- **Overview**: Submissions, approvals, reports, featured slots; AI dashboards (ServiceNow analytics).
- **Content**: Events, Venues, Categories, Tags, Organizers; partner integrations.
- **Monetization**: Featured placements, promo codes, VIP subscriptions.
- **Users/Roles**: Assign roles, verify organizers; AI risk management.
- **Settings**: Branding, regions, moderation policy, rate limits; AI workflow automation.
- **Audit Log**: Tracks actions.

---

## 4) Information Architecture
- **Spaces**: Public app (Home/Explore/Details), Member space (Saved/Submit/Community), Backoffice (Moderator/Admin).
- **Taxonomy**: Categories (Music, Sports, Family, Business, Meetups, Track Events, Travel Adventures), free-form Tags (e.g., "solo-friendly," "cultural immersion").
- **Geography**: Country → City/Parish; venues store lat/lng; multi-currency/language support.

---

## 5) Firestore Data Model
> Use **Cloud Firestore** with Firebase Storage for media. Collection-per-entity with subcollections for ownership/history. Enhanced with AI and travel fields.

### 5.1 Collections & Fields

**`events`** (top-level)
- `id` (auto)
- `title`: string
- `slug`: string (unique, shareable URLs)
- `categoryId`: ref → `categories/{id}`
- `tagIds`: string[] (e.g., "meetup", "track-event", "traveler-friendly")
- `startAt`: timestamp
- `endAt`: timestamp
- `isAllDay`: bool
- `recurrence`: object | null  
  `{ type: 'none'|'weekly'|'monthly', interval: number, byWeekday?: number[] }`
- `timezone`: string (IANA)
- `venueId`: ref → `venues/{id}`
- `location`: geopoint
- `isVirtual`: bool
- `virtualLink`: string | null
- `priceTier`: 'free'|'$'|'$$'|'$$$'
- `ticketUrl`: string | null (or integrated ticketing data)
- `posterUrl`: string
- `galleryUrls`: string[]
- `trackRoute`: object | null (e.g., { gpxUrl: string, distance: number })
- `organizerId`: ref → `organizers/{id}`
- `status`: 'pending'|'approved'|'rejected'|'archived'
- `flags`: { spam:boolean, nsfw:boolean, keywords:string[] }
- `rankScore`: number (AI-computed for Top 10)
- `aiRecommendations`: string[] (similar events)
- `travelerPerks`: object | null (e.g., { partnerDiscounts: string[] })
- `createdBy`: ref → `users/{id}`
- `createdAt`: timestamp
- `updatedAt`: timestamp
- `approvedAt`: timestamp | null
- `region`: string

**`venues`**
- `name`, `addressLine`, `city`, `region`, `country`
- `geo`: geopoint
- `placeId`: string (optional, Google/Apple)
- `contact`: { phone, email, website }
- `accessibility`: { wheelchair:boolean, parking:boolean, restroom:boolean }
- `travelerNotes`: string (e.g., "Near airport")

**`categories`**
- `name`, `slug`, `iconKey`
- `order`: number
- `active`: bool

**`tags`**
- `name`, `slug`

**`organizers`**
- `name`, `bio`, `avatarUrl`
- `links`: { website, instagram, tiktok, youtube }
- `verified`: bool
- `ownerUserId`: ref → `users/{id}`
- `partners`: string[] (e.g., hotel affiliations)

**`users`**
- `displayName`, `photoURL`, `email`
- `role`: 'member'|'organizer'|'moderator'|'admin'|'premium'
- `reputation`: number
- `prefs`: { notifications:boolean, regions:string[], travelInterests: string[] }
- `connections`: ref[] → users
- `createdAt`

**`submissions`** (optional queue)
- `eventDraft`: object (minimal `events` shape)
- `submittedBy`: ref → `users/{id}`
- `status`: 'pending'|'approved'|'rejected'
- `moderationNotes`: string
- `aiFlags`: object (AI insights)
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

**`meetups`** (subcollection or standalone)
- `eventId`, `attendees`: ref[], `chatHistory`: array

**`system`** (singleton doc)
- `rateLimits`: { submissionsPerMonth:number }
- `regions`: string[]
- `partners`: object (e.g., airline/hotel integrations)

### 5.2 Indexing (Composite Examples)
- `events`:
  - `status + startAt`
  - `region + status + startAt`
  - `categoryId + status + startAt`
  - `rankScore + status`
  - `tagIds + location` (traveler/meetup searches)
- Geoqueries: Use `location` with geohash utility for radius filtering.

### 5.3 Security Rules (Sketch)
```javascript
match /databases/{db}/documents {
  function isSignedIn() { return request.auth != null; }
  function isRole(r) { return isSignedIn() && request.auth.token.role == r; }
  function hasAnyRole(arr) { return isSignedIn() && arr.hasAny([request.auth.token.role]); }

  match /events/{id} {
    allow read: if resource.data.status == 'approved';
    allow create: if isSignedIn();
    allow update, delete: if hasAnyRole(['moderator','admin']);
  }

  match /users/{uid}/bookmarks/{eventId} {
    allow read, write: if isSignedIn() && request.auth.uid == uid;
  }

  match /users/{uid}/connections/{connId} {
    allow read: if isSignedIn();
    allow write: if isSignedIn() && request.auth.uid == uid;
  }

  match /featuredSlots/{id} {
    allow read: if true;
    allow write: if hasAnyRole(['admin']);
  }
}
```

### 5.4 Cloud Functions
- **onCreate(`events`)**: Compute `rankScore`, AI spam/keyword scan, notify moderators, generate traveler guides.
- **scheduled**: Archive past events, recompute rankings, AI trend analysis.
- **moderation webhook**: Slack/Email with Approve/Reject links; AI assistance.
- **push notifications**: Saved event reminders, meetup RSVPs.
- **analytics**: Event views/saves, partner perk redemptions.

---

## 6) Monetization Model
- **Featured placements**: CPC/flat for `featuredSlots`.
- **Organizer subscriptions**: Verified badge, analytics, bulk upload, auto-approval, AI promotion.
- **Affiliate links**: Ticket partners, hotel/airline commissions (ASmallWorld model).
- **Premium Membership**: Ad-free, exclusive events, travel perks (hotel discounts, airline upgrades).
- **Integrated Ticketing**: Fees on ticket sales (Eventbrite model).

---

## 7) Success Metrics
- DAU/WAU, event view→save rate, save→attendance proxy, submission-to-approval time, % approved, report rate.
- Community: Meetup join rate, connection requests, traveler engagement.
- AI: Recommendation click-through, moderation efficiency.

---

## 8)

## Phased Implementation Plan (Recommended)

Below is a pragmatic, prioritized development roadmap that maps the ideas in this document to incremental phases. Each phase includes acceptance criteria, estimated effort, and suggested tech pieces that align with the repo's Flutter + Firebase (Firestore, Cloud Functions, FCM) stack.

Phase 0 — Foundations (required pre-MVP) — 1–2 weeks
- Goal: Stabilize data model, authentication, rules, and developer workflows so feature work can proceed safely.
- Tasks:
  - Finalize Firestore schemas (events, users, venues, organizers, submissions, bookmarks).
  - Implement role-aware Firestore security rules (member/organizer/moderator/admin).
  - Add basic onboarding to capture `travelInterests`/`prefs` in `users/{userId}`.
  - Wire FCM and calendar export hooks for reminders.
- Acceptance criteria:
  - Basic auth and Firestore flows work end-to-end in dev.
  - Rules block unauthorized writes and submissions populate `submissions` for moderation.

Phase 1 — MVP Discovery + Community (4–6 weeks)
- Goal: Ship discovery, submission, and community features to validate product-market fit for traveler-first meetups and track events.
- Core features:
  1. Home feed (list + map) with search/filters and event details.
  2. Submit-event flow (AI-assisted suggestions) + moderation queue.
  3. Save/Bookmark, RSVP/Join, basic in-app event chat, and post-event reviews.
  4. Traveler mode (location-based recommendations and traveler tags).
  5. Organizer profile and verification request.
- Tech pieces:
  - Firestore collections and indexes per Section 5.
  - Cloud Function trigger onCreate for basic `rankScore` computation and optional AI-moderation webhook integration.
  - Use Riverpod providers (existing) for feed state and queries.
- Acceptance criteria:
  - Users can discover, save, and join meetups; submissions enter moderation.
  - Traveler mode surfaces relevant events with traveler tags.

Phase 2 — Organizer Tools, Waitlist & Ticketing (6–10 weeks)
- Goal: Provide organizers capacity controls, waitlists, and free ticket issuance (server-signed QR tokens).
- Core features:
  1. Waitlist & capacity management with Cloud Function promotions + FCM/Email notifications.
  2. Free ticketing: ticket issuance as server-signed tokens and a check-in verification endpoint.
  3. Organizer dashboard with basic analytics and featured slot purchases.
- Tech pieces:
  - Cloud Functions for transactional logic (promote waitlist, create reservations).
  - Firestore subcollections `events/{eventId}/tickets` and `events/{eventId}/waitlist`.
  - Stripe sandbox preparation (for paid flows in Phase 3).
- Acceptance criteria:
  - Waitlist promotion works reliably under concurrency tests.
  - Tickets can be issued (free) and verified via server endpoint (no duplicate redemption).

Phase 3 — Paid Ticketing, Promotions & Premium (8–12+ weeks)
- Goal: Launch payment flows, monetization, and premium features for travelers and organizers.
- Core features:
  1. Stripe integration: payment intents, receipts, refunds, webhooks.
  2. Promo codes, referral discounts, marketplace for featured placements.
  3. Premium traveler subscription (ad-free, perks) and partner affiliate integrations.
- Tech pieces:
  - Cloud Functions for webhook handling and payouts.
  - Order and payout schema additions and reconciliation processes.
  - Optional BigQuery or analytics pipeline for large-scale reporting.
- Acceptance criteria:
  - End-to-end paid checkout in sandbox with receipts and refund flows.
  - Premium members receive promised perks and partner flows are testable.

Phase 4 — Advanced AI Personalization & Growth (ongoing)
- Goal: Improve retention and revenue with server-side recommendations, AI tools for organizers, and growth mechanisms.
- Core features:
  - Server-side recommendations service (Cloud Run or Cloud Function) with nightly recompute.
  - AI-driven organizer tools (audience matching, promo text generation).
  - Growth tooling: referral tracking, A/B experiments for featured placements.

Phase completion checklist (applies to all phases)
- Unit & widget tests for new UI/providers.
- Integration smoke test for critical flows (auth, feed, submission, push notifications).
- Manual security review of Firestore rules and Cloud Functions.

Immediate next step (high-impact, low-risk)
- Implement an `interests` onboarding screen and a client-side `Recommended for you` feed section (MVP recommender using Firestore queries and client scoring). This is small, measurable, and increases engagement quickly.

If you'd like, I can create a branch and PR that:
- Adds `docs/phase-plan.md` (clean actionable checklist),
- Implements the onboarding UI to save `users/{userId}.interests`, and
- Adds a `Recommended` feed component that uses existing `firestore_service.dart` and Riverpod providers.

Tell me which immediate task to pick and I'll create the branch and start implementing (I'll update the todo list and mark the task in-progress before making code changes).