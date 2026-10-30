# TruthLayer · MVP 0.1.0

A Next.js application for submitting factual corrections, assessing submitted evidence, independent human review, publishing approved records, and retrieving those records through a developer API. Built for a **new, dedicated Supabase project** and a **new Vercel project**. Do not deploy over AfterHours AI or Cash Gap.

## What is implemented

- Responsive midnight/cyan interface, public directory, record pages, trust page, and API docs.
- Supabase email/password signup, sign-in/out, confirmation callback, reset and session refresh.
- Private draft saving, structured propositions, evidence links/excerpts, submission tracking.
- OpenAI structured extraction and assessment, with explicit unavailable states.
- Database-enforced review transitions, independent reviewer requirement, source-review attestation, immutable version snapshots, public decisions and private notes.
- Public JSON projections that omit draft versions, ownership, internal notes, and submitted excerpts.
- REST lookup, filters, date intervals, pagination, hashed developer keys, revocation, counts and persistent rate limits.
- Signed-in dispute reporting and reviewer report/audit views.
- Live baseline/assisted comparison using the same model and settings; separate labeled synthetic walkthrough.
- Standalone API consumer in `scripts/consumer.mjs` demonstrates retrieval by a separate process without database access.
- Exact duplicate active submissions by the same user are blocked; retries with the same request ID return the existing claim.

## Start locally (Windows PowerShell)

Install Node.js 22 or later. Extract the ZIP. Open the `truthlayer` folder in VS Code, then Terminal → New Terminal:

```powershell
npm ci
Copy-Item .env.example .env.local
npm run dev
```

Open the printed localhost URL. The landing page and synthetic walkthrough work before credentials are configured. Account/record functions show an explicit setup message. They do not use fake persistence.

## 1. Create and migrate Supabase

1. Create a **new** Supabase project named TruthLayer.
2. In its SQL Editor, run `supabase/migrations/001_truthlayer.sql` **once**. It creates the schema, functions, policies, and profile trigger. This is a fresh-install migration, not an idempotent upgrade.
3. In project API settings, copy the project URL, legacy anon key, and service-role key into `.env.local` using the exact variable names below. The service-role key is server-only.
4. Enable email/password authentication and email confirmation. Configure a production email sender/SMTP before opening signup to customers; the provider's default email limits are unsuitable for a public launch.
5. Auth → URL Configuration: set Site URL to your final app origin. Add `http://localhost:3000/auth/callback`, `http://localhost:3000/auth/callback?next=/account/password`, and equivalent production URLs to the redirect allowlist. Use your actual production domain.
6. Sign up one submitter account and a **separate** reviewer account. Confirm both emails.
7. In trusted SQL Editor access, promote the intended reviewer:

```sql
update public.profiles
set role = 'reviewer'
where id = (select id from auth.users where email = 'REPLACE_WITH_REVIEWER_EMAIL');
```

Never grant reviewer status based on user-editable metadata. The reviewer cannot approve their own claim. Role changes require trusted database access; no self-promotion endpoint exists.

## 2. Environment variables

| Variable | Purpose | Public? |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Dedicated project URL | Yes |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anon key; RLS protects records | Yes |
| `SUPABASE_SERVICE_ROLE_KEY` | Server-side public projection, quotas, assessment writes, keys | **No** |
| `OPENAI_API_KEY` | Extraction, assessment and comparison | **No** |
| `OPENAI_MODEL` | Structured-output capable model; default `gpt-4.1-mini` | No |
| `APP_URL` | Exact canonical browser origin, e.g. `https://your-project.vercel.app` | Not a secret |
| `RATE_LIMIT_SECRET` | Random secret for hashed IP quota identifiers | **No** |

Generate a rate secret locally:

```powershell
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

Never paste secrets into source files or chat. Set them in `.env.local` for development and in Vercel Environment Variables for deployment. Environment changes require a new deployment. Keep `APP_URL` consistent with the final redirected browser address (including `www` if used). Mutation requests from other origins are denied.

## 3. Deploy to Vercel

Use a **new** Vercel project, not your receptionist project.

1. Upload this folder to a new GitHub repository (exclude `.env.local`, `node_modules`, `.next`). Import that repository in Vercel, or run `npx vercel` in the `truthlayer` folder and select **create a new project**.
2. Framework: Next.js. Root Directory: the directory containing this `package.json` (blank if the repository root is this folder; `truthlayer` if you pushed its parent).
3. Add the environment variables to Production. Set `APP_URL` to the exact production URL. Set the matching Supabase redirect URLs.
4. Deploy with `npx vercel --prod`, or deploy the connected repository from Vercel.
5. Check `/api/v1/health`: `database: true` and `ai_configured: true` indicate database connectivity and key presence. Health does **not** prove successful OpenAI billing/access or email delivery.
6. Run the end-to-end smoke procedure below before sharing public traffic.

No Vercel account was modified by this build. No remote Supabase migration was run. No real OpenAI calls were executed without credentials.

## 4. End-to-end acceptance procedure

1. Sign up as a submitter, confirm email, log in, save a draft, reload, and confirm persistence.
2. Use a low-risk factual company/product statement with actual independently checkable evidence. Do not publish the fictional Aster example as a real correction.
3. Extract propositions; select one; edit the proposed value; add HTTPS source URLs, dates and an excerpt. Submit. Confirm status SUBMITTED and that an anonymous public lookup returns no record.
4. If OpenAI is configured, run assessment and inspect its output. Every URL must remain labeled NOT_RETRIEVED. Unavailable AI must not lose the saved claim or publish it.
5. Log in as the separate reviewer. Move SUBMITTED → UNDER_REVIEW. Open original source pages independently. Check entity, dates, relevance, privacy, and whether evidence supports the exact correction.
6. Select VERIFIED, enter a public reason, and check the independent-review attestation. Confirm the public page and API now expose the correction and sources, not internal notes or submitted excerpts.
7. Create a developer key. Copy it once. Test lookup, date filters, no-match queries, pagination, and revocation. A revoked key returns 401 and does not fall back to anonymous access.
8. In Live comparison, enter the exact entity/predicate, a relevant question and date. Inspect both answers and the retrieved record. Identical answers are valid; the baseline is never deliberately made wrong.
9. Run the standalone consumer below from another terminal/process. It retrieves through the API only.
10. Report the published correction as disputed. A reviewer marks it DISPUTED; confirm it disappears from verified lookup while the public record remains labeled disputed.
11. Test password reset, sign-out, and another ordinary user's inability to view drafts/review tools.
12. Check mobile layouts and a production email confirmation with a real inbox.

```powershell
npm test
npm run typecheck
npm run build
node scripts/smoke.mjs https://YOUR_PRODUCTION_DOMAIN
```

### Independent AI consumer

Supply environment variables locally (never commit values): `TRUTHLAYER_URL`, `TRUTHLAYER_API_KEY`, `OPENAI_API_KEY`, optionally `OPENAI_MODEL`.

```powershell
npm run demo:consumer -- "Your Entity" "founding_year" "When was Your Entity founded?"
```

This script calls the actual REST API and OpenAI. It does not connect to Supabase or import the site's claim engine. It prints both answers, retrieved records, timestamps, and model identity. Model knowledge and evidence may agree already. Improved answers require a relevant, credible correction and model compliance; the program does not manufacture an improvement.

## Architecture

- Claim engine: `lib/domain.ts`, SQL `save_claim`, private workspaces.
- Review engine: `lib/ai-core.ts`, `lib/ai.ts`, SQL `review_claim`, reviewer UI.
- Distribution engine: SQL `public_records`, `/api/v1/*`, public pages, standalone consumer.
- Authorization: validated Supabase user on every private server request; RLS and narrowly scoped SECURITY DEFINER functions enforce ownership and review rules. No client write policies.
- Production facts are never seeded. The fictional walkthrough exists only in `lib/domain.ts` and UI; SYNTHETIC is not a valid database claim status.
- Verified facts cannot be edited. New facts require a new claim; old facts can be superseded while their immutable snapshots remain.

## Tests and validation limits

See `VALIDATION.md` for executed results. PostgreSQL tests run the actual migration in PGlite with auth roles and RLS, not a JavaScript imitation. Supabase's hosted Auth/email service and PostgREST are not running inside those tests. AI boundary tests use controlled mock provider responses, not paid API calls. A passing local suite does not replace the deployment smoke test above.

## Known limits / unfinished production operations

- Source URLs are **not fetched**. No automatic source verification, crawling, or SSRF-capable fetch endpoint exists. Reviewers open evidence themselves. Assessment is of supplied text only.
- Live Supabase signup/email/reset, remote migrations, real AI outputs and Vercel deployment need operator credentials and remain unverified until the smoke procedure succeeds.
- Category and privacy checks use submitter acknowledgment plus human review; automated PII/defamation detection is not implemented. No unrestricted private-person publication workflow.
- No background queue. Assessment is a bounded synchronous request, retryable manually after failure.
- Reviewer trust remains an operational responsibility. There is no reviewer accreditation or second-reviewer consensus requirement.
- Duplicate detection is exact and owner-scoped. Cross-user semantic duplicate merging and entity disambiguation are future work.
- Dashboard/review lists cap at 100 records; audit/report lists at 50. API directory has pagination. Sitemap currently includes the 50 most recently active public records.
- No billing, organization tenancy, SSO, reviewer notifications, deletion UI, automated data-retention jobs, or source snapshots. Configure retention and monitoring before public production use.
- Public API quotas: 30/minute per hashed Vercel-forwarded IP; key quotas 120/minute per key. Outside Vercel, anonymous requests share a fallback bucket. Direct public projection RPC execution is restricted to service_role so users cannot bypass API quotas through it. Public record page HTML remains crawlable.
- Usage counts reflect authenticated requests reaching the lookup layer, including requests whose later validation fails; they are not billing-grade metering.
- Public corrections expose only current approved facts plus public decision history; published version snapshots are expandable on the public record page; private draft snapshots remain available to database operators.
- No claim of automatic adoption by ChatGPT, Claude, Gemini or external AI providers.

## Next three improvements

1. Complete a staging deployment with real email, two test accounts, reviewer approval, a real source, and the standalone consumer; retain the acceptance evidence.
2. Add a vetted evidence-fetching service with DNS/IP pinning, per-hop redirect checks, content limits, snapshots, and adversarial SSRF tests.
3. Add reviewer notifications, privacy triage, resolution of dispute reports, semantic duplicate suggestions, and a small measured evaluation set for retrieval accuracy.
