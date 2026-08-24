# Privacy Policy

**Effective date**: February 23, 2026
**Last updated**: August 24, 2026

Potion (withpotion.io) is operated by 9592 Solutions UG (haftungsbeschrankt), Fahrstr. 217, 40221 Dusseldorf, Germany. We are the data controller for the personal data described in this policy.

**Privacy contact**: christo@withpotion.io. We respond to data subject requests within 30 days.

---

## What Potion is

Potion is an API for AI agents. Agents create RSS podcast feeds, upload audio episodes, have text narrated into audio, point Potion at articles to read aloud, and manage content. Humans subscribe to those feeds in their podcast apps. An assistant such as ChatGPT or Claude can also be connected to an account directly, over OAuth.

There is no dashboard and no marketing platform. The web pages we serve are the ones the service needs in order to work: the magic link verification page shown after signup, the sign-in page you reach when connecting an assistant and the page its emailed link opens, the pages Stripe returns you to after checkout, and the public page for a shared episode.

This shapes what we collect: we have no browsing sessions and no typical web analytics. Almost everything we know about you comes from API calls made on your behalf. The exception is shared episode pages, where we count a view against the episode and record nothing about the person who opened it.

---

## Data we collect and why

### Account data

When you sign up, we store:

- Email address
- API key (displayed in plaintext once at verification, stored server-side for authentication)
- Subscription tier (free, plus, or pro)
- Stripe customer ID and subscription ID (if you upgrade)
- Storage usage in bytes
- Account creation and update timestamps
- Connector records: which assistants have been connected to your account, and their access tokens stored as SHA-256 hashes rather than in readable form
- A record of each text-to-speech job: the voice used, the number of characters submitted, the seconds of audio produced, and when

Legal basis: performance of a contract (GDPR Art. 6(1)(b)). We need this data to authenticate requests, enforce limits, and manage billing.

### Feed and episode content

When your agent creates feeds or adds episodes, we store:

- Feed titles, descriptions, author names, and configuration
- Episode titles and descriptions
- Uploaded audio files, and audio Potion produced for you (both stored in Cloudflare R2)
- External audio URLs (stored as references, not proxied or cached by us)
- Text you submitted for narration, and text Potion extracted from a URL you gave it, stored alongside the job that produced the episode
- Optional metadata your agent provides: `use_case` (feed-level), `generated_by`, `content_type`, `source` (episode-level)

Legal basis: contract for feed and episode content. Legitimate interest (Art. 6(1)(f)) for optional metadata, which helps us understand what people are building. Optional metadata is never required and we do not prompt agents to collect it from users.

Audio files are stored and served as-is. We do not analyze, transcribe, or scan audio content.

### Optional agent metadata

Your agent may optionally include structured metadata fields when creating feeds or episodes:

**Feed-level:**
- `use_case` - what the feed is for (e.g., "daily email digest")

**Episode-level:**
- `generated_by` - the model or system that produced the content (e.g., "claude-3.5-sonnet")
- `content_type` - a descriptor for the content (e.g., "news briefing")
- `source` - where the content originated (e.g., "email", "arxiv", "rss")

These fields are entirely optional. We do not require them, we do not prompt agents to collect them from users, and the API works identically whether they are provided or not. If provided, they are used only in aggregate to understand what people are building on Potion (e.g., "most common use cases this month"). We do not surface this data per-user or share it outside the company.

Legal basis: legitimate interest (Art. 6(1)(f)).

### Text to speech and article reading

When you have Potion narrate something, the text is sent to a synthesis provider so it can return the audio. Which provider it goes to depends on the voice you chose.

Standard voices are synthesized by DeepInfra, in the United States. DeepInfra's terms state that data submitted to the service is not retained beyond the period needed to process and return the request, and its privacy policy says it will not store, sell, or train on that data without explicit consent.

Premium voices are synthesized by OpenAI, in the United States. OpenAI states that data sent to its API is not used to train its models unless you opt in, and that inputs to the speech endpoint are retained for up to 30 days for abuse monitoring.

Only the text to be narrated and the name of the voice are sent. Your email address, your account ID, and your API key are not.

When you point Potion at a URL, Potion fetches the page itself from Cloudflare's network, identifying itself as `PotionBot`. If that fetch fails or the page yields nothing usable, the URL - and only the URL - is passed to Jina AI's Reader service, which fetches the page and returns its text. Jina AI GmbH is registered in Berlin; it does not publish where the Reader service runs. Its terms state that it stores inputs and outputs only to the extent required to provide the service, and does not use customer inputs to train its models.

Legal basis: performance of a contract. Narrating text and reading an article are things you asked Potion to do.

### Analytics (Mixpanel)

We track API usage events such as feed and episode creation, deletion, and access; signup and authentication events, including connector sign-ins; billing events; rate limit or upload rejection events; text-to-speech jobs; article extractions; and views of shared episode pages.

Event properties include things like file size, MIME type, source type, the voice used, characters submitted and seconds of audio produced, and, for an article extraction, the hostname of the page. We do not send the text you had narrated, the text extracted from a page, or the full URL.

For events that belong to an account, we use your user ID as the Mixpanel distinct ID. Signup and connector sign-in happen before we know which account is involved, so those events are keyed by the email address entered instead. A view of a shared episode page is keyed by the episode. We do not send your API key to Mixpanel.

Legal basis: legitimate interest. We use this data to understand how Potion is used and to make product decisions.

### Error tracking (Sentry)

When the API encounters errors, we log error events, stack traces, and request metadata to Sentry. We do not intentionally include personal data in error events. Sentry is hosted in the EU (de.sentry.io).

Legal basis: legitimate interest. We need error data to keep the service running reliably.

### Billing (Stripe)

If you upgrade to Potion Plus, you pay via Stripe Checkout. Card numbers and payment details never touch our servers. We store only your Stripe customer ID and subscription ID.

---

## Third-party processors

We share data with the following processors:

| Processor | Purpose | Location |
|---|---|---|
| Cloudflare | Workers compute, R2 audio storage, CDN | Global |
| Neon | PostgreSQL database | us-east-1, United States |
| Resend | Transactional email (magic link, connector sign-in) | United States |
| Stripe | Payment processing | United States |
| Sentry | Error tracking | EU (de.sentry.io) |
| Mixpanel | Usage analytics | United States |
| DeepInfra | Text-to-speech, standard voices | United States |
| OpenAI | Text-to-speech, premium voices | United States |
| Jina AI | Article extraction, fallback only | Germany (company registration) |

Each processor is engaged under data processing terms covering the service we use. International transfers rely on the EU-US Data Privacy Framework and/or Standard Contractual Clauses (SCCs).

---

## RSS feeds

RSS feeds are served at secret URLs. The URL is unguessable - it contains a nanoid with sufficient entropy to be practically private. There is no authentication on the RSS endpoint by design, so podcast apps can subscribe directly.

We do not track who subscribes to feeds. We observe podcast client user-agent strings in aggregate analytics only. We have no way to link a podcast app subscription to an individual user.

---

## Shared episode pages

Every episode has a public page at an unguessable URL, and anyone holding that URL can play the episode without signing in. The page does not reveal which feed the episode belongs to or where that feed is served.

We count a view against the episode and record nothing about the person viewing. The pages are served with a header asking search engines not to index them.

A shared episode page loads its audio, and its artwork if it has any, from wherever the episode points. That is usually Potion's own storage, but it can be another host if the feed's owner set one, in which case that host sees the request.

---

## Cookies and tracking

None of the pages listed under What Potion is sets a cookie, stores anything in your browser, or loads external scripts or tracking pixels. Each is a self-contained HTML page served directly from our Worker. The one thing any of them fetches from elsewhere is a shared episode's own audio and artwork, described above.

We do not use cookies anywhere on withpotion.io.

---

## Data retention

| Data type | Retention period |
|---|---|
| Account data | Duration of account, plus 30 days after deletion |
| Audio files (R2), uploaded and generated | Deleted when episode or feed is deleted, or when account is closed |
| Text-to-speech usage records | Duration of account |
| Render jobs, including the submitted or extracted text | Duration of account |
| Connector sign-in attempts | Purged 14 days after they lapse; removed with the account |
| Connector access tokens (stored hashed) | Purged 30 days after they expire or are revoked; removed with the account |
| Pending signups | Auto-expire and are purged daily |
| Account deletion confirmations | Purged daily after completion or expiry |
| Analytics events | 12 months (Mixpanel project setting) |
| Error events | 90 days (Sentry project setting) |

---

## Your rights (GDPR Art. 15-22)

If you are in the EU/EEA, you have the right to:

- **Access**: request a copy of your personal data
- **Rectification**: correct inaccurate data
- **Erasure**: request deletion of your data
- **Restriction**: limit how we process your data while a dispute is resolved
- **Portability**: receive your data in a machine-readable format
- **Objection**: object to processing based on legitimate interest

To exercise any of these rights, email christo@withpotion.io. We will respond within 30 days. At this stage, account deletion and data export are handled manually on request.

If you believe we are processing your data unlawfully, you have the right to lodge a complaint with your supervisory authority. Our lead authority is:

**Landesbeauftragte fur Datenschutz und Informationsfreiheit NRW (LDI NRW)**
Kavalleriestr. 2-4
40213 Dusseldorf, Germany
https://www.ldi.nrw.de

---

## What we do not do

- We do not sell personal data to anyone.
- We do not use personal data for advertising.
- We do not share aggregate analytics outside the company.
- We do not direct our service at children under 16. If you are under 16, do not use Potion.

---

## Changes to this policy

When we make material changes to this policy, the `Last updated` date at the top changes. Because this file lives in a public GitHub repository, you can diff any two versions: `git log PRIVACY.md`. We will not make retroactive changes that reduce your rights without notice.

---

## Contact

Questions about this policy: christo@withpotion.io

9592 Solutions UG (haftungsbeschrankt)
Fahrstr. 217
40221 Dusseldorf, Germany
VAT ID: DE364316497
