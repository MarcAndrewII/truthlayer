# Start here — TruthLayer

This folder is the full application. It is a separate project from AfterHours AI and Cash Gap.

## See it on your computer

1. Install Node.js 22 or later.
2. Extract this ZIP and open the `truthlayer` folder in VS Code.
3. Open Terminal → New Terminal.
4. Run `npm ci`.
5. Run `npm run dev`.
6. Open the localhost URL printed in the terminal.

The homepage and clearly labeled fictional walkthrough work without keys. Accounts, saved claims, reviewer tools and live AI require the configuration below.

## Make the real pipeline work

1. Create a NEW Supabase project. Run `supabase/migrations/001_truthlayer.sql` once in its SQL Editor.
2. Copy `.env.example` to `.env.local`. Fill in the Supabase URL, anon key, service-role key, OpenAI key and random rate-limit secret. Keep secrets out of chat and Git.
3. Configure Supabase email confirmation and redirect URLs as described in README.md.
4. Create two separate accounts: one submitter and one reviewer. Promote the reviewer using the exact SQL in README.md.
5. Submit a factual correction with real evidence. Review it with the separate reviewer account and publish only after checking its sources.
6. Retrieve it from `/api/v1/lookup`, then run the Live comparison or independent consumer script.

## Put it on Vercel

1. Create a NEW GitHub repository containing this folder's contents, then import it as a NEW Vercel project.
2. Choose Next.js. The root directory must contain `package.json`.
3. Add all `.env.example` variables in Vercel. Set `APP_URL` to the final production origin.
4. Add the production callback URLs in Supabase and deploy.
5. Run `node scripts/smoke.mjs https://YOUR_DOMAIN` and the full README acceptance procedure.

Use a new Vercel project. Do not import this over your existing receptionist website.

## Files to know

- `README.md`: exact setup, keys, reviewer promotion, deployment and acceptance steps.
- `VALIDATION.md`: checks actually run and checks still requiring live services.
- `supabase/migrations/001_truthlayer.sql`: database schema, policies and functions.
- `scripts/consumer.mjs`: independent AI application using the public API.
- `docs/PRODUCT-BRIEF.md`: original product requirements.

The implementation passes 34 tests, type checking and the production build. It has not been deployed to your Vercel account. Live accounts, email, AI results and browser behavior remain to be verified with your configuration.
