# Phase 2 — Organizer Tools & Monetization (6–10 weeks)

Goal: Add deeper organizer features, monetization channels, and productivity tools that allow organizers to manage events at scale and pay for promotions.

Scope & Deliverables
- Organizer profiles: rich bio, social links, analytics dashboard
- Bulk upload CSV import with validation and mapping wizard
- Organizer subscription plans: verified badge, bulk-import allowance, priority moderation
- Featured slots marketplace: admin UI to sell/manage slots, organizer UI for checkout
- Promo codes and billing integration (Stripe) for subscriptions and featured placements
- Advanced ticket support: external ticket links and affiliate tracking (utm)
- Enhanced analytics: views, saves, ticketClicks, conversions exported to BigQuery
- Auto-approval rules for verified organizers (configurable)

Data & Schema updates
- Add `organizer` fields for subscription status and limits
- Add `featuredSlots` inventory documents and campaign records
- Add `billing` collection under organizers for invoices and payment status
- Add `events.metrics` or `events_metrics/{eventId}` with sharded counters for high write volume

Security & Compliance
- Require additional verification documentation upload for organizer verification
- Limit bulk uploads behind verified organizer role and rate limits
- Stripe PCI compliance note: never store card data; use Stripe hosted components

Milestones & Timeline (6–10 weeks)
1. Week 1–2: Organizer profile page + analytics views
2. Week 3–4: Bulk import CSV wizard + validation endpoints
3. Week 5–6: Featured slots UI + admin inventory management
4. Week 7–8: Stripe integration for subscriptions + checkout
5. Week 9–10: Auto-approval rules, billing pages, and QA

Developer tasks
- Add organizer subscription fields to `organizers` collection
- Create CSV import Lambda / Cloud Function with validation and dry-run
- Build featured slots purchase flow and admin allocation UI
- Integrate Stripe connect or regular Stripe depending on marketplace model

Acceptance criteria
- Organizers can view analytics and consumption of featured slots
- Bulk import handles validation errors and does not create invalid events
- Subscriptions and payments recorded in organizer billing collection

Notes
- Consider using Stripe Connect if organizers need payouts
- Use server-side functions to apply featured slot purchases to `featuredSlots`
- Keep rate-limits and quotas configurable in `system/config`