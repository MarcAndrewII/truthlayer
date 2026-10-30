# TRUTHLAYER

### The Universal AI Knowledge Correction Network

**Vision: Correct information once. Make the correction accessible to every AI.**

## 1. The idea behind TruthLayer

Artificial intelligence has a fundamental limitation that most people haven’t considered.

**When someone corrects an AI assistant, that correction doesn’t automatically improve the information available to everyone else.**

Imagine discovering that ChatGPT, Claude, and Gemini are all providing outdated information about your business.

You correct ChatGPT. It acknowledges the correction.

But another person asks the same question tomorrow and receives the same incorrect answer.

Why?

Because personal conversations, model training, and globally accessible knowledge are separate systems.

**TruthLayer would create a shared infrastructure for correcting AI-accessible knowledge.**

The platform would allow individuals, companies, researchers, and organizations to submit factual corrections, provide evidence, and make verified information available through a standardized knowledge API.

Rather than requiring AI companies to retrain their models every time something changes, participating applications could query TruthLayer for relevant corrections before generating answers.

### The larger vision

TruthLayer could eventually become an independent knowledge infrastructure layer serving:

- AI assistants and autonomous agents
- AI application developers
- Enterprises and organizations
- Search and retrieval systems
- Researchers and publishers
- Individuals correcting public information about themselves, subject to identity verification and consent

Think of the opportunity this way:

**Search engines index information. TruthLayer indexes corrections, evidence, and changes to information.**

Its competitive advantage would not simply be storing facts. It would be tracking which claims have been challenged, what evidence supports competing versions, when facts changed, and which corrections are reliable enough for other systems to use.

The ultimate ambition is to become an infrastructure provider for AI information accuracy.

This does not mean TruthLayer could force ChatGPT or other AI systems to change their answers. It would provide a correction network that participating applications could integrate.

**The MVP must prove one thing: A correction submitted to TruthLayer can improve the response of an independent AI application without retraining its underlying model.**



---



# 2. EXACT GPT ASTRA BUILD PROMPT

Copy everything below into Astra.

# PROJECT: TRUTHLAYER

## Build a Production-Quality MVP of a Universal AI Knowledge Correction Network

You are my principal software architect, senior full-stack engineer, AI systems engineer, database architect, and product designer.

I am the founder of TruthLayer.

Your assignment is to build the first fully functional MVP of a potentially large-scale AI infrastructure company.

This is not a mockup, concept presentation, or static landing page.

I want a working, deployable software product with persistent storage, AI-assisted evidence assessment, public correction records, a developer API, and a live demonstration showing how TruthLayer can improve an AI application’s answers.

Do not respond with a development plan alone.

Build the application.

Make sound architectural decisions, implement the code, create the necessary database migrations, and deliver a complete runnable project.

If an external API key or service configuration is unavailable, implement the real integration boundary and a clearly labeled demonstration mode. Never represent simulated verification or mock data as real evidence.



---



# PART 1: PRODUCT VISION

TruthLayer is an independent infrastructure platform that helps correct inaccurate, outdated, or disputed information consumed by artificial intelligence systems.

Today, when someone corrects an AI assistant, the correction generally remains confined to that interaction or user-specific context.

TruthLayer creates a different workflow:

1. Someone encounters an incorrect AI-generated statement.
2. They submit the statement to TruthLayer.
3. They propose the correct information.
4. They provide supporting evidence.
5. TruthLayer evaluates the claim and evidence.
6. The claim enters an appropriate verification workflow.
7. An evidence-backed correction record becomes publicly accessible when publication requirements are satisfied.
8. Developers and AI agents can retrieve the record through an API.
9. A participating AI application can use that record to improve its answer without retraining the model.

Our central product promise:

**Correct it once. Make the correction discoverable everywhere.**

This is a distribution and interoperability ambition, not a claim that every AI provider automatically adopts our corrections.

TruthLayer must distinguish between:

- A submitted allegation
- A proposed correction
- An AI-generated assessment
- Independently supported evidence
- A verified correction
- A disputed claim
- An outdated or superseded claim

Never conflate these states.



---



# PART 2: TECHNICAL STACK

Use the following stack unless a compelling technical reason requires a change.

Frontend:

- Next.js with App Router
- React
- TypeScript
- Tailwind CSS
- Responsive, mobile-first layouts

Backend:

- Next.js server routes
- Supabase PostgreSQL
- Supabase Auth
- Supabase Row Level Security
- Server-side validation using Zod

AI:

- OpenAI API
- Structured JSON outputs where supported
- Strict server-side API-key handling

Deployment:

- Vercel

Supporting technologies:

- GitHub-ready repository
- Environment variable configuration
- Automated tests
- Rate limiting
- Server-side logging
- Database migrations

Use established, actively maintained packages.

Avoid unnecessary infrastructure.

Build the system so the MVP can evolve into a standalone API business.



---



# PART 3: DESIGN SYSTEM

TruthLayer should look like a serious AI infrastructure company.

Visual references:

- Modern developer platforms
- Enterprise knowledge infrastructure
- Premium SaaS dashboards
- Clean research and verification interfaces

Design direction:

Primary background: Near-black or deep midnight navy

Secondary surfaces: Dark charcoal

Primary accent: Electric cyan

Secondary accent: Emerald green

Typography: Modern, precise, highly readable

Style:

- Sophisticated
- Minimal
- Technical
- Trustworthy
- Premium
- Confident

Avoid:

- Generic AI gradients everywhere
- Cartoon robots
- Excessive glowing elements
- Cryptocurrency-style aesthetics
- Overloaded dashboards
- Fake enterprise logos
- Fabricated usage statistics

The website should feel like an infrastructure company capable of serving enterprise AI developers.

Create excellent desktop and mobile experiences.



---



# PART 4: PUBLIC LANDING PAGE

Build a compelling homepage.

## Hero

Headline:

**AI gets things wrong. TruthLayer helps correct the record.**

Subheadline:

**Submit disputed AI claims, evaluate supporting evidence, and make corrections available to connected applications through one knowledge API.**

Primary CTA:

**Challenge a Claim**

Secondary CTA:

**Explore the API**

Below the hero, create a visual workflow:

AI Answer → Claim Challenged → Evidence Reviewed → Correction Published → AI Retrieves Update

Include an interactive demonstration preview.

## Additional homepage sections

### The Problem

Explain how corrections made inside individual AI conversations do not automatically become globally available knowledge.

### The Solution

Explain TruthLayer’s claim records, evidence assessment, version history, and developer API.

### How It Works

Show the complete correction lifecycle.

### For Developers

Explain how applications can retrieve relevant evidence-backed corrections.

### For Businesses

Explain how organizations can challenge outdated information about their products, policies, services, and public business details.

### Trust and Verification

Explain that TruthLayer does not accept every submitted correction as true.

### Final CTA

**Help build a more accurate AI ecosystem.**

Do not fabricate customers, endorsements, partnerships, accuracy metrics, or enterprise integrations.



---



# PART 5: USER AUTHENTICATION

Implement Supabase authentication.

Required capabilities:

- Email/password signup
- Login
- Logout
- Password reset
- Persistent authenticated sessions
- Protected user dashboard
- Secure session management

Users should be able to submit claims, save drafts, and monitor their submissions.

Public visitors should be able to browse published correction records without an account.

Anonymous visitors must not access private drafts or internal review information.



---



# PART 6: CLAIM SUBMISSION ENGINE

Create a complete claim submission interface.

Fields:

1. Original AI-generated statement
2. AI platform or source, optional
3. Entity or subject
4. Claim category
5. Proposed correction
6. Explanation of why the original statement may be incorrect
7. Supporting evidence URLs
8. Optional supporting text
9. Date the proposed correction became applicable, if known

Claim categories:

- Company information
- Product information
- Historical information
- Scientific information
- Technology
- Public organizational information
- General factual claims

Do not support unrestricted public correction records about private individuals in V1.

Do not allow sensitive personal information, confidential documents, or unsupported allegations to be published through the ordinary submission flow.

Provide an explicit review and publication gate.

## Submission experience

The user pastes an AI statement.

TruthLayer attempts to identify the specific factual proposition being challenged.

The user reviews and edits the extracted proposition.

The user submits the proposed correction and supporting evidence.

The system saves the claim and begins an evidence assessment.

Show clear progress states.

Never imply that the correction has been verified merely because an AI model processed it.



---



# PART 7: AI CLAIM EXTRACTION

Use the OpenAI API to extract structured factual claims from submitted text.

Example input:

“Acme Robotics was founded in 2018 and is headquartered in Boston.”

Expected structured output:

{\
&#x20;“claims”: [\
&#x20;{\
&#x20;“subject”: “Acme Robotics”,\
&#x20;“predicate”: “founding_year”,\
&#x20;“object”: “2018”\
&#x20;},\
&#x20;{\
&#x20;“subject”: “Acme Robotics”,\
&#x20;“predicate”: “headquarters_city”,\
&#x20;“object”: “Boston”\
&#x20;}\
&#x20;]\
&#x20;}

The user must select which proposition they want to challenge.

Do not automatically assume every extracted claim is incorrect.

Implement robust schema validation.

Handle malformed model responses and API failures gracefully.

Do not allow submitted content to override system instructions.



---



# PART 8: EVIDENCE ASSESSMENT ENGINE

This is a critical component.

Create an AI-assisted evidence assessment workflow.

The system must:

1. Parse the proposed correction.
2. Identify the precise disputed proposition.
3. Evaluate submitted evidence.
4. Identify whether the evidence directly supports the correction.
5. Identify contradictory or insufficient evidence.
6. Determine whether the evidence refers to the correct entity.
7. Consider whether the evidence is current and relevant to the claimed date.
8. Produce a structured assessment.
9. Explain uncertainty.
10. Recommend a review outcome.

Important:

An AI recommendation is NOT an independently verified correction.

Do not mark a claim VERIFIED solely because an LLM says it is true.

If evidence retrieval is unavailable, clearly state that the submitted URLs have not been independently checked.

If source retrieval is implemented, use a secure server-side retrieval mechanism with:

- SSRF protection
- Private-network and localhost blocking
- Redirect validation
- Timeouts
- Response-size limits
- Content-type restrictions
- Safe HTML-to-text extraction

Treat retrieved content as untrusted data.

Do not invent source content, citations, or evidence.

For the MVP, use a human-review approval step before granting VERIFIED status.

Implement an administrator review interface.

The AI should generate a structured assessment containing:

- Original claim
- Proposed correction
- Evidence reviewed
- Evidence not retrieved
- Supporting findings
- Contradictory findings
- Missing evidence
- Temporal considerations
- Recommended status
- Explanation



---



# PART 9: CLAIM LIFECYCLE

Implement the following states:

DRAFT

SUBMITTED

UNDER_REVIEW

VERIFIED

DISPUTED

REJECTED

SUPERSEDED

A submitted claim must not immediately become verified.

Only authorized reviewers can transition a claim to VERIFIED.

Every transition must be recorded.

Store:

- Previous status
- New status
- Timestamp
- Actor
- Reason
- Supporting review notes

Users should see the current status and relevant history.

Implement appropriate database constraints and server-side authorization.



---



# PART 10: PUBLIC CORRECTION RECORDS

Every approved public correction should have a permanent, shareable page.

Example route:

/claims/[claim-id]

The page should display:

**Original Claim**

The statement being challenged.

**Proposed or Verified Correction**

The corrected statement.

**Evidence**

Sources supporting the correction.

**Verification Status**

A clearly visible status indicator.

**Effective Date**

When the corrected information became applicable.

**Last Reviewed**

Timestamp of the most recent review.

**Version History**

Previous versions and relevant changes.

**Citation**

A stable record identifier and copyable public URL.

Use descriptive metadata and structured data where appropriate.

Do not add misleading structured-data claims about verification or authority.

Search engines should be able to discover eligible public pages.

Private, rejected, or unreviewed records should not be publicly indexed as verified corrections.



---



# PART 11: TEMPORAL KNOWLEDGE MODEL

TruthLayer must understand that information changes over time.

Example:

A company may have one CEO in 2024 and another CEO in 2026.

Both statements may be correct for their respective dates.

Model claims using:

- Entity
- Predicate
- Value
- Valid-from date
- Valid-to date
- Evidence
- Verification status
- Version
- Review timestamp

Distinguish between:

- When something was true
- When the information was submitted
- When the information was reviewed
- When the record was updated

Do not overwrite historical claims without retaining their history.

Design the schema for eventual temporal knowledge graph functionality.



---



# PART 12: DEVELOPER KNOWLEDGE API

Build a functioning REST API.

Minimum endpoints:

GET /api/v1/claims

GET /api/v1/claims/:id

GET /api/v1/lookup

GET /api/v1/health

The lookup endpoint should support:

- Entity
- Predicate
- Search query
- Optional effective date

Example:

GET /api/v1/lookup?entity=Acme%20Robotics&predicate=founding_year

Example response:

{\
&#x20;“entity”: “Acme Robotics”,\
&#x20;“predicate”: “founding_year”,\
&#x20;“value”: “2016”,\
&#x20;“status”: “VERIFIED”,\
&#x20;“effective_date”: null,\
&#x20;“sources”: [\
&#x20;{\
&#x20;“title”: “Official incorporation record”,\
&#x20;“url”: “[https://example.com/record](https://example.com/record)”\
&#x20;}\
&#x20;],\
&#x20;“last_reviewed”: “2026-10-26T12:00:00Z”\
&#x20;}

This is an illustrative response, not a real verified claim.

## API requirements

- Consistent JSON schemas
- Input validation
- Pagination
- Clear error responses
- Rate limiting
- API keys for registered developers
- Hashed API-key storage
- Secure key creation and revocation
- Usage tracking
- No secrets in browser code
- No access to private records
- Documented response semantics

Public endpoints may expose limited approved records.

Private or higher-volume API access should require authentication.

Implement actual database-backed lookups.

Do not return fabricated verified claims when no matching record exists.



---



# PART 13: THE FLAGSHIP FEATURE

## BEFORE AND AFTER AI DEMONSTRATION

This is the most important demonstration in the MVP.

Build a page titled:

**See the Difference TruthLayer Makes**

The user enters a factual question.

The application generates two responses.

### LEFT PANEL

**AI Without TruthLayer**

The AI responds using its normal model context without querying TruthLayer.

### RIGHT PANEL

**AI With TruthLayer**

The application first searches TruthLayer for relevant verified correction records.

If a relevant record exists, the application supplies the record and its evidence to the AI before generating an answer.

The response must identify the correction record used.

Display:

- Question
- Baseline response
- TruthLayer-assisted response
- Retrieved claim
- Verification status
- Supporting evidence
- Retrieval timestamp

Both responses should use the same underlying model and comparable settings.

Clearly disclose that the comparison demonstrates retrieval-augmented answering, not an update to the model’s underlying weights.

If no relevant verified correction exists, display that honestly.

Do not manufacture a difference between the two answers.

Do not force the baseline answer to be wrong.

Do not tell the enhanced model to disagree with the baseline merely to make the demonstration look impressive.

### Demo mode

Include one clearly labeled synthetic demonstration record so the workflow can be tested before real corrections are verified.

Synthetic records must never be mixed into production verified search results.

Provide a demonstration dataset isolated from production data.

This page should make TruthLayer’s value immediately understandable.



---



# PART 14: USER DASHBOARD

Create a dashboard where users can view:

- Submitted claims
- Draft claims
- Claims under review
- Verified corrections
- Disputed claims
- Rejected claims
- Last activity
- Submission history

Allow users to:

- Create new submissions
- Edit drafts
- Review assessment findings
- Add supporting evidence
- View review decisions
- Open published correction pages

Do not allow ordinary users to change verification statuses.



---



# PART 15: ADMIN REVIEW DASHBOARD

Create a secure administrator interface.

Required capabilities:

- View pending submissions
- Review original and proposed claims
- Inspect retrieved evidence
- Review AI assessments
- View contradictory findings
- Approve or reject corrections
- Mark claims disputed
- Request additional evidence
- Supersede outdated corrections
- View audit logs

Admin access must be enforced server-side and in database policies.

Do not rely on hidden navigation links or client-side role checks.

Do not allow users to grant themselves administrator privileges.



---



# PART 16: DEVELOPER PORTAL

Create a developer dashboard.

Features:

- Generate API keys
- View API-key metadata
- Revoke API keys
- See request counts
- Access API documentation
- Test lookup queries

Show the full API key only once when created.

Never store raw API keys in the database.

Include copyable code examples using:

JavaScript

Python

cURL

Provide working examples that call the actual API.



---



# PART 17: DATABASE ARCHITECTURE

Design and implement a normalized PostgreSQL schema.

At minimum, consider these tables:

profiles

entities

claims

claim_versions

evidence_sources

evidence_assessments

claim_reviews

claim_status_history

api_keys

api_usage

audit_logs

Create additional tables where necessary.

Requirements:

- UUID primary keys
- Foreign-key constraints
- Useful indexes
- Timestamps
- Explicit ownership relationships
- Review history
- Versioning
- Supabase Row Level Security
- Appropriate uniqueness constraints

Do not rely on the frontend for data security.

Provide SQL migrations.

Ensure submitted claims cannot be silently modified after verification without creating a new version or review event.



---



# PART 18: SECURITY AND TRUST

This application handles potentially disputed public information.

Security and integrity are core product requirements.

Implement:

- Authentication and authorization
- Row Level Security
- Server-side input validation
- API rate limiting
- Protection against prompt injection
- Safe external URL handling
- Audit logging
- Abuse reporting
- Reviewable publication workflow
- Basic duplicate-claim detection
- Protection against mass automated submissions
- Secure environment variable management

Never allow an AI model to independently authorize its own verification decision.

Do not present unverified user assertions as authoritative facts.

Do not create public profiles or corrections containing sensitive information about private individuals.

Add an accessible correction-dispute process for published records.



---



# PART 19: SEARCH AND DISCOVERY

Build a public claims directory.

Features:

- Search by entity
- Search by keyword
- Filter by category
- Filter by status
- Sort by recent activity
- View correction detail pages

Prioritize database-backed search.

Do not introduce a separate search infrastructure unless necessary.

Only expose records appropriate for public viewing.



---



# PART 20: PERFORMANCE AND RELIABILITY

Implement:

- Loading states
- Empty states
- Error boundaries
- Graceful API failure handling
- Database query optimization
- Responsive UI
- Accessible forms
- Clear success and failure messages
- Retry-safe submission handling

Avoid duplicate submissions caused by repeated button clicks.

Use background processing where appropriate, but do not introduce unnecessary distributed infrastructure.



---



# PART 21: TESTING

Create meaningful automated tests.

At minimum, test:

1. User authentication and authorization
2. Claim submission validation
3. Claim extraction schema validation
4. Evidence assessment failure handling
5. Prevention of unauthorized verification
6. Status transition rules
7. Claim version history
8. API-key authentication
9. API-key revocation
10. Public/private record separation
11. Knowledge lookup behavior
12. Empty search results
13. Temporal claim filtering
14. Before-and-after demonstration
15. Prevention of synthetic demo records appearing as production verified facts

Include a smoke-test procedure for the deployed application.

Do not claim tests passed unless they were actually executed successfully.



---



# PART 22: DEPLOYMENT

Prepare the project for Vercel deployment.

Provide:

- Complete source code
- Package configuration
- Environment variable example
- Supabase migrations
- Database setup instructions
- OpenAI API configuration
- Build scripts
- Test scripts
- Deployment instructions
- README

Use environment variables for all credentials.

Do not hardcode secrets.

If you have terminal access, install dependencies, run the build, execute tests, and fix errors.

If you cannot execute a command, state that explicitly rather than claiming success.



---



# PART 23: PRIORITY ORDER

Build in this order:

PHASE 1:\
&#x20;Working project, database, authentication, and claim submission.

PHASE 2:\
&#x20;Claim extraction, evidence assessment, and administrator review.

PHASE 3:\
&#x20;Public correction records, versioning, and claim search.

PHASE 4:\
&#x20;Knowledge API, API keys, and developer documentation.

PHASE 5:\
&#x20;Before-and-after AI demonstration.

PHASE 6:\
&#x20;UI polish, testing, security review, and deployment preparation.

Every phase should leave the application in a runnable state.

If time is limited, prioritize a complete end-to-end vertical slice over partially implemented features.

The minimum acceptable result is:

A user submits a correction, a reviewer verifies it, the system publishes a record, and an independent AI workflow retrieves and uses that record.



---



# PART 24: FINAL DELIVERY REQUIREMENTS

When finished, provide:

1. The complete project files.
2. A summary of implemented functionality.
3. The database migration files.
4. Environment variables required.
5. Local development instructions.
6. Vercel deployment instructions.
7. Test results.
8. Known limitations.
9. Any incomplete features.
10. The next three highest-priority improvements.

Do not describe unfinished functionality as implemented.

Do not substitute static mockups for working backend functionality.

Do not use hardcoded sample claims as production records.

Do not invent evidence.

Do not claim integration with ChatGPT, Claude, Gemini, or any other external AI provider unless such an integration actually exists.

Do not claim TruthLayer can modify another company’s underlying AI model.

Build the infrastructure that makes verified corrections retrievable by applications that choose to integrate it.



---



# THE FOUNDER’S NON-NEGOTIABLE REQUIREMENT

TruthLayer must demonstrate this exact sequence:

**Incorrect or outdated AI claim → User-submitted correction → Evidence assessment → Authorized verification → Published correction → API retrieval → Improved AI answer.**

Every stage must be functional.

The product must have real database persistence, genuine API endpoints, secure authorization, and a working AI integration.

I am not asking for a pitch deck.

I am not asking for a landing page prototype.

I am asking you to engineer and deliver the first working version of TruthLayer.

Make architectural decisions independently, document important trade-offs, and start building now.



---



## 3. One architectural decision I strongly recommend

**Don’t let Astra build the entire platform as one enormous AI prompt-response system.**

The critical distinction is between three engines:

| **Engine**              | **Responsibility**                                                    |
| ----------------------- | --------------------------------------------------------------------- |
| **Claim Engine**        | Stores structured claims, evidence, history, and verification states  |
| **Verification Engine** | Assesses evidence and supports human review                           |
| **Distribution Engine** | Makes approved corrections accessible through APIs and public records |

These should be logically separated even if they initially run within one Next.js application.

That makes the system easier to test, maintain, and eventually scale.

## 4. The demonstration that could attract investors

Imagine showing an investor two independent AI applications.

You ask both:

**“When was Acme Robotics founded?”**

The first answers:

“2018.”

You submit a correction to TruthLayer with authoritative evidence establishing 2016.

A reviewer verifies it.

Then you ask the second AI application the same question.

It retrieves the TruthLayer correction and answers:

“2016, according to the verified correction record.”

**You have demonstrated knowledge transfer between applications without model retraining.**

That’s a meaningful technical proof of concept. It doesn’t yet establish market demand, universal adoption, or the reliability of the verification process, but it proves the fundamental integration mechanism.

### The strategic objective

Scale AI helped build infrastructure for preparing data used in AI development.

**TruthLayer’s ambition would be to build infrastructure for maintaining evidence-backed information after AI systems are deployed.**

That’s the category you’re investigating.

And for tonight, the most important deliverable isn’t the homepage.

**It’s a working correction-to-API-to-AI pipeline.**
