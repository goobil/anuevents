# Phase 3 — Scale, Social & Web (8–16 weeks)

Goal: Evolve the product into a social, multi-region platform with a web presence, recommendations, and advanced analytics.

Scope & Deliverables
- Web app launch (responsive) and SEO-friendly event pages
- Social features: follow organizers, friends, event commenting, RSVP signals
- Recommendation engine: event suggestions using collaborative filtering or heuristics
- Reviews & ratings per event with moderation
- Multi-region support and localized content
- Performance & scalability: migrate heavy analytics to BigQuery, optimize indexes
- Admin features: content moderation tooling with machine learning assist

Data & Schema updates
- Add social graph collections: `follows`, `friends` or a graph service
- Add `comments` subcollection on events with moderation status
- Add `rsvps` with privacy considerations (public/private) and throttling
- Add `searchIndex` or integrate external search (Algolia/Meili) for full-text

Milestones & Timeline
1. Weeks 1–4: Web app basics + public SEO pages for events
2. Weeks 5–8: Social graph and follow features + notifications
3. Weeks 9–12: Comments/ratings and recommendation prototype
4. Weeks 13–16: Scale testing, BigQuery exports, ML-assist for moderation

Developer Tasks
- Build web frontend: Flutter Web or React for SEO needs (consider hybrid)
- Implement follow model and feed personalization rules
- Integrate Algolia/Meilisearch for fast, fuzzy search
- Add comment moderation queue and rate-limiting

Acceptance Criteria
- Web event pages are crawlable and render correctly
- Users can follow organizers and see personalized recommendations
- Platform handles multi-region content and localized feeds

Notes
- For SEO, server-side rendering or prerendering might be necessary depending on stack
- Carefully design data retention and privacy for social features (GDPR/CCPA)