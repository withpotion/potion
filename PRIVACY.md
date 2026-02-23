# Privacy Policy

**Effective date**: February 23, 2026
**Last updated**: February 23, 2026

Potion (withpotion.io) is operated by 9592 Solutions UG (haftungsbeschrankt), Fahrstr. 217, 40221 Dusseldorf, Germany. We are the data controller for the personal data described in this policy.

**Privacy contact**: hello@withpotion.io. We respond to data subject requests within 30 days.

---

## What Potion is

Potion is an API for AI agents. Agents create RSS podcast feeds, upload audio episodes, and manage content. Humans subscribe to those feeds in their podcast apps. There is no website, no dashboard, and no marketing platform. The only web page we serve is the magic link verification page shown after signup.

This shapes what we collect: we do not have page views, browsing sessions, or typical web analytics. Everything we know about you comes from API calls your agent makes on your behalf.

---

## Data we collect and why

### Account data

When you sign up, we store:

- Email address
- API key (stored as a hash internally, displayed in plaintext once at verification)
- Subscription tier (free or plus)
- Stripe customer ID and subscription ID (if you upgrade)
- Storage usage in bytes
- Account creation and update timestamps

Legal basis: performance of a contract (GDPR Art. 6(1)(b)). We need this data to authenticate requests, enforce limits, and manage billing.

### Feed and episode content

When your agent creates feeds or adds episodes, we store:

- Feed titles, descriptions, author names, and configuration
- Episode titles and descriptions
- Uploaded audio files (stored in Cloudflare R2)
- External audio URLs (stored as references, not proxied or cached by us)
- Optional metadata your agent provides: `use_case`, `generated_by`, `content_type`

Legal basis: contract for feed and episode content. Legitimate interest (Art. 6(1)(f)) for optional metadata, which helps us understand what people are building. Optional metadata is never required and we do not prompt agents to collect it from users.

Audio files are stored and served as-is. We do not analyze, transcribe, or scan audio content.

### Analytics (Mixpanel)

We track API usage events including: `feed_created`, `episode_added`, `episode_deleted`, `feed_deleted`, `feed_accessed`, `signup_initiated`, `signup_confirmed`, `stripe_checkout_started`, `subscription_activated`, `rate_limit_hit`, `upload_rejected`.

Event properties include things like file size, MIME type, and source type. We use your user ID as the Mixpanel distinct ID. We do not send your email address or your raw API key to Mixpanel.

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
| Resend | Transactional email (magic link) | United States |
| Stripe | Payment processing | United States |
| Sentry | Error tracking | EU (de.sentry.io) |
| Mixpanel | Usage analytics | United States |

All US-based processors have Data Processing Agreements in place. International transfers rely on the EU-US Data Privacy Framework and/or Standard Contractual Clauses (SCCs).

---

## RSS feeds

RSS feeds are served at secret URLs. The URL is unguessable - it contains a nanoid with sufficient entropy to be practically private. There is no authentication on the RSS endpoint by design, so podcast apps can subscribe directly.

We do not track who subscribes to feeds. We observe podcast client user-agent strings in aggregate analytics only. We have no way to link a podcast app subscription to an individual user.

---

## Cookies and tracking

The magic link verification page sets no cookies and loads no external scripts or tracking pixels. It is a self-contained HTML page served directly from our Worker.

We do not use cookies anywhere on withpotion.io.

---

## Data retention

| Data type | Retention period |
|---|---|
| Account data | Duration of account, plus 30 days after deletion |
| Audio files (R2) | Deleted when episode or feed is deleted, or when account is closed |
| Pending signups | Auto-expire and are purged daily |
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

To exercise any of these rights, email hello@withpotion.io. We will respond within 30 days. At this stage, account deletion and data export are handled manually on request.

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

Questions about this policy: hello@withpotion.io

9592 Solutions UG (haftungsbeschrankt)
Fahrstr. 217
40221 Dusseldorf, Germany
VAT ID: DE364316497
