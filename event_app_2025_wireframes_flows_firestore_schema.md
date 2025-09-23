# Event App (2025)

## 1) Personas & Roles

- **Guest:** Browse, search, and filter events. Guests are prompted to sign
  in for saves or submissions.
- **Member:** Submit events, bookmark, share, receive reminders, join meetup
  chats, and connect with attendees.
- **Organizer (verified):** Manage organizer profile, bulk upload events,
  and view simple analytics.
- **Moderator:** Approve/deny submissions, edit content, and handle reports.
- **Admin:** Full control over feature slots, categories, roles, and audits.

---

## 2) Core User Flows (MVP)

1. Discover → Details → Save/Share

  Home feed → tap card → event details → save/share/open map.

1. Submit Event → Moderation → Publish

  Auth gate → form → upload poster → submit → pending review → publish.

1. Search & Filter

  Keyword + filters: date range, category, location radius, price.

1. Reminders

  Saved events trigger push notifications 24h and 1h before start.

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
```text

**Event Card:** Poster, title, date/time, venue, distance, price chip,
and a save icon.

### 3.2 Explore (Map + Filters)

```text
[ Map view with clustered pins ]
[ Filter drawer: date | category | distance | price | accessibility ]
```text

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

Use Cloud Firestore with Firebase Storage for media. Collections are organized
per entity, with subcollections for ownership and history. The model is
denormalized where it helps read performance.

### 4.1 Collections & Fields

**events** (top-level)

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

**venues**

- name, addressLine, city, region, country
- geo: geopoint
- placeId: string (optional)
- contact: { phone, email, website }
- accessibility: { wheelchair:boolean, parking:boolean, restroom:boolean }

**categories**

- name, slug, iconKey
- order: number
- active: bool

### 4.2 Indexing (Examples)

- events: status + startAt
- region + status + startAt
- categoryId + status + startAt
- rankScore + status

Geoqueries: use location with a geohash utility (e.g., geofirex) for
radius filtering.

### 4.3 Security Rules (Sketch)

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

  match /featuredSlots/{id} {
    allow read: if true; // public read for rendering
    allow write: if hasAnyRole(['admin']);
  }
}
```javascript

### 4.4 Cloud Functions

- onCreate(events): compute rankScore, run spam/keyword scans, notify
  moderators
- scheduled: archive past events, recompute rankings, run trend analysis
- moderation webhook: Slack/email with Approve/Reject deep links
- push notifications: saved event reminders (24h / 1h)
- analytics aggregation: event views and saves counts

---

## 5) Monetization & Roadmap

Monetization (optional): featured placements (CPC/flat), organizer
subscriptions, affiliate links, and premium traveler membership.

Roadmap (high level):

MVP (4–6 weeks)

- Home/Explore + search & filters
- Event details
- Auth + submit flow
- Moderator queue + approval
- Saved events + notifications

Phase 2

- Organizer profiles & bulk import
- Featured slots & monetization
- Reviews/ratings

Phase 3

- Social graph (follow friends/organizers)
- Recommendation feed
- Web app

---

## 6) Testing, Privacy & Implementation Notes

- Unit tests for form validation and ranking logic
- Integration tests for submission→approval→publish
- Device matrix testing (low-end Android to latest iPhone)

- Privacy: minimize PII, avoid storing exact attendee lists
- Safety: media scanning for unsafe content, rate-limit flows

Implementation tips:

- Denormalize for reads (snapshot category.name on events)
- Use server timestamps and FieldValue.increment for metrics
- Keep search simple initially; add Algolia/Meilisearch later

### Sample Documents

events/{id}

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
```text

users/{uid}/bookmarks/{eventId}

```json
{ "createdAt": "2025-07-28T12:11:00Z" }
```json

---

Deliverables Recap

- Wireframes (text) for MVP screens
- Firestore schema, indexes, rules sketch
- Roadmap and metrics to guide rollout

> Ready for sprint planning and developer handoff.

```json
