# TruthLayer MVP — validation record

Validated October 27, 2026 (America/New_York).

## Executed successfully

- `npm test`: **34 passed, 0 failed**.
- `npm run typecheck`: passed.
- `npm run build`: passed; Next.js production build generated all 20 listed app routes plus middleware.

The database suite executes `supabase/migrations/001_truthlayer.sql` in PGlite (PostgreSQL). It creates simulated Supabase authentication roles and exercises actual SQL functions and RLS. It does not replace SQL with mocked JavaScript.

### Covered behavior

- Persistent database writes, idempotent submission retry, draft edits and immutable snapshots.
- Ordinary members cannot change roles, review claims, edit another member's drafts, or read another member's keys.
- Reviewers cannot review their own submissions; approval requires the correct transition and evidence attestation.
- Public projections hide drafts, ownership, internal notes and submitted evidence excerpts.
- Public version history contains only previously published snapshots.
- Anonymous and authenticated users cannot call the projection RPC directly to bypass API quotas; service_role can.
- Temporal and entity filters; empty lookup; disputed-record exclusion from verified lookup.
- API-key generation, hashing, revocation and private storage; database rate counters.
- Malformed/refused AI outputs, provider outages and fabricated retrieval claims are rejected or explicitly disclosed.
- Before/after answers use the same model and settings; only retrieved context differs.
- Synthetic demonstration data is ineligible for verified production records.

## Verification not completed

- Browser visual/interaction testing: managed preview reported it had started, then stopped. The browser returned `ERR_CONNECTION_REFUSED`. No screenshot or mobile pass is claimed.
- `scripts/smoke.mjs`: included for the deployed site, but could not reach the stopped local preview. No HTTP smoke pass is claimed.
- Real Supabase Auth signup, confirmation email, password reset and session-cookie flows.
- A remote Supabase migration, production PostgREST integration and real account authorization.
- Paid OpenAI requests, model availability/billing and a real correction improving a model answer.
- Vercel deployment, live domain, SMTP delivery and production performance/load tests.

These operations require a configured staging environment. Follow README sections 1–4 and retain the output of the standalone API consumer before describing the system as live and validated end to end.

## Release boundary

This package is a runnable MVP implementation, not evidence of a production deployment. Evidence URLs are not fetched automatically. Publication depends on an independent human reviewer. There is no automatic propagation into external AI providers.
