# Privacy Policy

**Effective date**: February 23, 2026
**Last updated**: October 29, 2026

Potion (withpotion.io) is operated by 9592 Solutions UG (haftungsbeschrankt), Fahrstr. 217, 40221 Dusseldorf, Germany. We are the data controller for the personal data described in this policy.

**Privacy contact**: christo@withpotion.io. We respond to data subject requests within 30 days.

---

## What Potion is

Potion is an API for AI agents. Agents create RSS podcast feeds, upload audio episodes, have text narrated into audio, point Potion at articles to read aloud, and manage content. Humans subscribe to those feeds in their podcast apps. An assistant such as ChatGPT or Claude can also be connected to an account directly, over OAuth.

There is no dashboard and no marketing platform. The web pages we serve are the ones the service needs in order to work: the magic link verification page shown after signup, the sign-in page you reach when connecting an assistant, which also has a box for emails that help you get started if you want them, a page where you sign in with an emailed code to choose a paid plan before paying through Stripe, a page that a link in a free feed, or on that feed's page in a browser, opens, which shows the plan that fits that show and lets you pay through Stripe without signing in, a page that emails a subscriber a link to the Stripe billing page, pages for confirming or withdrawing an email preference, the pages Stripe returns you to after checkout, the public page for a shared episode, the page a feed's address shows when it is opened in a web browser, a page of links to these documents at `/legal`, and two short introduction pages, at `/daily` and `/start`, for people who hear about Potion outside of an assistant.

This shapes what we collect: we have no browsing sessions and no typical web analytics. Almost everything we know about you comes from API calls made on your behalf. Three things sit outside that. We count a view against the episode when someone opens a shared episode page, and record nothing about the person who opened it. We log requests for your feeds and episodes against the feed, so we can tell whether anything is reaching a podcast app. And we count views and clicks on the introduction pages, with nothing about who they came from. All three are described below.

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

If your assistant asks for an upload link, the episode's title, description and other details are stored with the link until the file arrives, and the link itself is stored only as a hash. The link works once, for one hour, and creates one episode in one feed.

Legal basis: contract for feed and episode content. Legitimate interest (Art. 6(1)(f)) for optional metadata, which helps us understand what people are building. Optional metadata is never required and we do not prompt agents to collect it from users.

Audio files are stored and served as-is. We do not analyze, transcribe, or scan audio content.

### Optional agent metadata

Your agent may optionally include structured metadata fields when creating feeds or episodes, or when asking Potion to narrate an episode:

**Feed-level:**
- `use_case` - what the feed is for (e.g., "daily email digest")

**Episode-level:**
- `generated_by` - the model or system that produced the content (e.g., "claude-3.5-sonnet")
- `content_type` - a descriptor for the content (e.g., "news briefing")
- `source` - where the content originated (e.g., "email", "arxiv", "rss")

**Narration:**
- `started_by` - whether a scheduled or recurring task started the episode or the user asked for it (`scheduled_task` or `user_request`)

These fields are entirely optional. We do not require them, we do not prompt agents to collect them from users, and the API works identically whether they are provided or not. If provided, they are used only in aggregate to understand what people are building on Potion (e.g., "most common use cases this month"). We do not surface this data per-user or share it outside the company.

Legal basis: legitimate interest (Art. 6(1)(f)).

### Text to speech and article reading

When you have Potion narrate something, the text is sent to a synthesis provider so it can return the audio. Which provider it goes to depends on the voice you chose.

Standard voices are synthesized by DeepInfra, in the United States. DeepInfra's terms state that data submitted to the service is not retained beyond the period needed to process and return the request, and its privacy policy says it will not store, sell, or train on that data without explicit consent.

Premium voices are synthesized by OpenAI, in the United States. OpenAI states that data sent to its API is not used to train its models unless you opt in, and that inputs to the speech endpoint are retained for up to 30 days for abuse monitoring.

Only the text to be narrated and the name of the voice are sent. Your email address, your account ID, and your API key are not.

When you point Potion at a URL, Potion fetches the page itself from Cloudflare's network, identifying itself as `PotionBot`. If that fetch fails or the page yields nothing usable, the URL - and only the URL - is passed to Jina AI's Reader service, which fetches the page and returns its text. Jina AI GmbH is registered in Berlin; it does not publish where the Reader service runs. Its terms state that it stores inputs and outputs only to the extent required to provide the service, and does not use customer inputs to train its models.

Every episode Potion narrates carries marks that say it was made by AI: a signed record inside the MP3 file (Content Credentials, the C2PA standard) that names the text-to-speech model, and, for standard voices, a watermark in the sound. Neither mark contains your name, your account, your feed or the episode's title. Potion signs the record itself. The only outside service involved is DigiCert's public time-stamping server, which receives a fingerprint of the signature and nothing else.

When Potion adds these marks to an episode made before it began marking, it keeps a copy of the original file for 30 days in case the change has to be undone, then deletes it. Deleting the episode deletes the copy too.

Legal basis: performance of a contract. Narrating text and reading an article are things you asked Potion to do.

### Feed and episode requests

When a podcast app fetches one of your feeds, or downloads an episode we host, we record that the request happened. Podcast apps do not report anything back to the publisher, so a server log is the only way to know whether a feed reached anybody.

Each record holds which feed it was, which episode where there was one, whether the request came from a podcast app, a browser or a crawler, the app's name where the User-Agent says so plainly, how many bytes we sent, and when.

We do not store your IP address. We use it, together with the User-Agent, to compute a short key that lets us tell one app's several requests for the same episode apart from several different apps asking once each. Without that, a player fetching a long episode in five pieces would look like five downloads. The key is computed through a secret we hold, through the date, and through the episode, so the same app produces a different value tomorrow and a different value for the next episode. It cannot be used to follow anyone across days or across episodes, and it cannot be turned back into an address.

Opening a feed's address in a web browser shows a page that helps you add the feed to a podcast app, instead of the feed itself. That request is recorded the same way, as a browser asking for the feed.

We classify the requesting app only coarsely: podcast app, browser or crawler, plus its name where that is unambiguous. We do not build a device fingerprint, and we do not route these requests through a third-party measurement service. Our error tracker receives a timing record for about one request in ten, without the IP address, as described under Error tracking below.

Records of individual requests are deleted after 14 days. Before they are deleted they are counted into daily totals per feed, episode and app type, and those totals are kept. The totals carry no per-request key and cannot be resolved back to a client.

The owner of a feed can see three facts from these records about their own feed: whether a podcast app has fetched it, which app it was where the app names itself, and when the first and the latest fetch happened.

Legal basis: legitimate interest (Art. 6(1)(f)). We need to know whether feeds are being delivered at all, and to size storage and bandwidth.

### The plan page and the links to it

On the Free tier, the copy of your feed that podcast apps receive, and the page your feed's address opens in a web browser, can carry a link to a page that shows the plan that fits your show (see the Terms, Section 4). The link is signed with a secret Potion holds and names your account, where it was placed (the show notes, the notice item or the feed's page in a browser) and when it expires, which is 60 days after it was made. It is not stored: Potion checks it by recomputing the signature. Anyone holding your feed's address can open the page, so the page shows only what a podcast app already shows of your feed - its name and artwork - plus how much you have narrated and the plan that fits it. It does not show your email address, and Stripe Checkout is not given it: whoever pays types their own.

A subscriber who opens that page is offered an email to their account's own address with a link to the Stripe billing page. That link works for an hour.

We count a view of the page, a press of a plan button and a request for a billing link, each with where the link was placed. These counts are in the Mixpanel paragraph below.

Legal basis: performance of a contract, for showing your plan and starting a checkout you ask for; legitimate interest (Art. 6(1)(f)) for counting which links are used.

### Emails about your account

Besides sign-in codes and confirmation links, Potion sends four kinds of email about an account:

- once, when the free narration runs out: what happened and what still works. It mentions no plan and no price.
- when a subscriber asks for it from the plan page or at `api.withpotion.io/billing`: a link to the Stripe billing page.
- when someone ticks one of the email preferences, on the plan page or on the sign-in page: a request to confirm it, sent to the account's own address.
- when a fault on Potion's side stopped something you tried to do, such as narration or an upload that failed: a note saying what went wrong, that it is fixed and how to try again. It goes once for each such fault and mentions no plan and no price.

We keep a record of which of these was sent to an account and when, without its content, so the credit notice is sent only once and the others cannot be sent to an address over and over by someone else.

Legal basis: performance of a contract.

### The email preference

The plan page has a box to tick for emails about narration running out and about Potion's plans. Ticking it sends the account's address a request to confirm, because the plan page can be opened by anyone holding the feed's address. Only a confirmed preference counts. We store the exact wording you agreed to and its version, where you ticked it, when you asked and when you confirmed. You can withdraw it at any time with the link in any such email, or by writing to christo@withpotion.io; the record of the withdrawal is kept with it.

When you sign in you can also tick a box for setup help. If you confirm it, Potion sends you at most three short notes in your first month, each only if it still applies: how to make a first episode if you haven't made one, and how to make the next part of something you started. They mention no plan and no price, they stop once you have a show running, and every one has a link to stop them. We store the same record as for the plan emails. One unsubscribe link, or an email to christo@withpotion.io, stops both kinds. Neither kind of email is sent today.

Legal basis: consent (Art. 6(1)(a)) for the emails; legal obligation and legitimate interest (Art. 6(1)(c) and (f)) for keeping the record, so we can show what was agreed.

### The introduction pages

Potion serves two short introduction pages, at `api.withpotion.io/daily` and `api.withpotion.io/start`, for people who hear about it in a video or a post rather than through an assistant. Opening a page counts a view, and pressing one of its buttons counts a press. A link to either page can carry a campaign label, such as a video id, and the label is stored with the count.

A record from `/daily` holds the event, the label, which assistant the button led to, and the time.

A record from `/start` holds the same, plus three more things. The first is which button was pressed, including the button that copies a prompt to paste into another assistant. The second is whether the visitor was on a phone or a computer, which we read from the browser's User-Agent and keep only as one of those two words. The third is how long after the page opened the button was pressed, kept only as one of four ranges (under 10 seconds, 10 to 30 seconds, 30 seconds to 2 minutes, longer). The browser works out the range and sends only that, so no finer timing reaches us.

A record from `/start` also holds the visitor's country. Cloudflare, which runs our servers, works out the country from the IP address before the request reaches our code, and we store only the two-letter country code. Our code never reads or stores the IP address itself.

There is no cookie and no visitor identifier on either page, so a view cannot be tied to the press that follows it, to another visit, or to any account. The records can say how many views a given video produced, from which countries and on which kind of device, and how many presses followed. They cannot say anything about a person.

Legal basis: legitimate interest (Art. 6(1)(f)). We need to know whether telling people about Potion in a video brings anyone to it, and which parts of the page they use.

### Reports about content

When someone reports content as illegal (Terms of Service, Section 11), we keep the report, including the reporter's name and email address where they gave them, our decision, and a record of what we removed, why, and which account it belonged to. We use this to handle the report, to tell the reporter and the account holder what we decided, to deal with a challenge to that decision, and to defend against legal claims about the content. We do not tell the account holder who made a report unless the law requires it.

Legal basis: legal obligation (Art. 6(1)(c)), because the Digital Services Act requires us to handle reports and explain our decisions, and legitimate interest (Art. 6(1)(f)) in defending against claims.

### Analytics (Mixpanel)

We track API usage events such as feed and episode creation, deletion, and access; signup and authentication events, including connector sign-ins, with whether the setup-help box was ticked, and sign-ins on the plan page; billing events; upload links being created; rate limit, plan limit or upload rejection events; text-to-speech jobs; article extractions; each call an assistant makes to one of Potion's tools through a connector, with which tool it was, whether it worked, was refused or failed, and the name and version the assistant's app gives for itself and which protocol features it says it supports, but nothing that was sent to the tool; views of shared episode pages, and views of the page a feed's address shows in a browser. views of the plan page, presses of its plan buttons and requests for a billing link, each with where the link was placed; when an account's free narration passes one hour and when it runs out; when a credit-ended email or a billing link is sent; downloads of the notice item in a free feed, with whether the request came from a podcast app; and when an email preference is asked for, confirmed or withdrawn, with which box it came from.

Event properties include things like file size, MIME type, source type, the voice used, characters submitted and seconds of audio produced, whether a scheduled task or the user started a narration when the assistant said so, and, for an article extraction, the hostname of the page. We do not send the text you had narrated, the text extracted from a page, or the full URL.

For events that belong to an account, we use your user ID as the Mixpanel distinct ID. Signup, connector sign-in and the plan page's sign-in code happen before we know which account is involved, so those events are keyed by the email address entered instead. A view of a shared episode page is keyed by the episode. A request for one of your feeds, and a view of the page a feed's address shows in a browser, are keyed by a code we derive from the feed using a secret we hold, and the same code stands in for the feed wherever another event refers to one. We do not send a feed's address or its ID to Mixpanel, and we do not send your API key.

Legal basis: legitimate interest. We use this data to understand how Potion is used and to make product decisions.

### Error tracking (Sentry)

When a request fails inside Potion, we send Sentry a record of the failure. For about one request in ten we also send a timing record, which shows us what is slow. Requests for feeds, episode audio and shared episode pages are included in both.

A record holds the following:

- the error and where in our code it happened
- the request's method and address, which for a feed request is the feed's address
- the requesting app's User-Agent and a few technical headers, such as the content type
- for a signed-in request, the account's ID and tier
- the messages our code logged while handling the request, and the host names of the other services Potion contacted to answer it
- for a billing notification we could not match to an account, the Stripe customer ID

Before a record leaves Potion we remove the requester's IP address, credentials and cookies, and the values of anything after the `?` in the address. We also remove the single-use token in a sign-in or confirmation link, the values a failed database query was run with, and anything in the error text that is shaped like an email address.

Sentry is hosted in the EU (de.sentry.io) and keeps these records for 30 days.

Legal basis: legitimate interest. We need error and timing data to keep the service running reliably.

### AI tools we use to run Potion

We use AI assistants in our own work on Potion: Claude, made by Anthropic, and ChatGPT and Codex, made by OpenAI. Both companies are based in the United States. When we use them to fix a problem, change the service or understand how it is used, they see whatever we give them from our database and logs. That can include any of the data described in this policy, such as account IDs, email addresses, the titles and descriptions of feeds and episodes, and the text of episodes.

Legal basis: legitimate interest (Art. 6(1)(f)). These tools are how we build and run Potion, and that work means looking at real records.

### Billing (Stripe)

If you upgrade to Potion Plus, you pay via Stripe Checkout. Card numbers and payment details never touch our servers. We store only your Stripe customer ID and subscription ID.

---

## Third-party processors

We share data with the following processors:

| Processor | Purpose | Location |
|---|---|---|
| Cloudflare | Workers compute, R2 audio storage, CDN | Global |
| Neon | PostgreSQL database | us-east-1, United States |
| Resend | Transactional email (magic link, sign-in codes, account notices) | United States |
| Stripe | Payment processing | United States |
| Sentry | Error tracking | EU (de.sentry.io) |
| Mixpanel | Usage analytics | United States |
| DeepInfra | Text-to-speech, standard voices | United States |
| OpenAI | Text-to-speech, premium voices | United States |
| Jina AI | Article extraction, fallback only | Germany (company registration) |

Each processor in this table is engaged under data processing terms covering the service we use. International transfers rely on the EU-US Data Privacy Framework and/or Standard Contractual Clauses (SCCs).

Anthropic and OpenAI also receive data from our own use of their AI tools, described above under AI tools we use to run Potion.

---

## RSS feeds

RSS feeds are served at secret URLs. The URL is unguessable - it contains a nanoid with sufficient entropy to be practically private. There is no authentication on the RSS endpoint by design, so podcast apps can subscribe directly.

Every feed carries the standard tags that ask podcast directories not to list it publicly (`itunes:block` and `podcast:block`).

Opened in a web browser, a feed's address shows a page with buttons for several podcast apps. A button hands the feed's address to the app you choose. Some podcast apps, Pocket Casts and Overcast among them, fetch feeds from their provider's servers and not from your phone, so that provider then holds the address as well. The page's QR code is drawn by Potion itself, and the address is not sent to any other service to make it.

We do not know who subscribes to a feed. A podcast app does not identify itself or its user, and nothing in the request tells us who is holding the URL.

We do record that the request happened, against the feed. Because a feed belongs to an account, those records are linkable to the account that owns the feed - they are covered under Feed and episode requests above. What they cannot do is say anything about the person at the other end: there is no subscriber identifier, and the key that groups one app's repeated requests is different every day.

---

## Shared episode pages

Every episode has a public page at an unguessable URL, and anyone holding that URL can play the episode without signing in. The page does not reveal which feed the episode belongs to or where that feed is served.

We count a view against the episode and record nothing about the person viewing. The error tracker's records described under Error tracking apply to these pages as they do to any request: they hold the browser's User-Agent and not the IP address. The pages are served with a header asking search engines not to index them.

A shared episode page plays its audio through the page's own address rather than the file's. Audio Potion holds is passed through by Potion, so nothing about where the file is stored reaches the person listening. Audio hosted elsewhere - an address the feed's owner supplied - is redirected to that host, which then sees the request. Artwork, if the episode has any, is still loaded from wherever it points.

---

## Cookies and tracking

None of the pages listed under What Potion is sets a cookie, stores anything in your browser, or loads external scripts or tracking pixels. Each is a self-contained HTML page served directly from our Worker. The only things any of them may fetch from elsewhere are a feed's or a shared episode's artwork, and an episode's audio when that audio is hosted somewhere other than Potion. The page a feed's address shows can also place that address on your clipboard, when you press its copy button or its Apple Podcasts button.

We do not use cookies anywhere on withpotion.io.

---

## Data retention

| Data type | Retention period |
|---|---|
| Account data | Duration of account, plus 30 days after deletion |
| Audio files (R2), uploaded and generated | Deleted when episode or feed is deleted, or when account is closed |
| Copies of episodes' original audio kept when they were marked | 30 days, or until the episode is deleted |
| Text-to-speech usage records | Duration of account |
| Render jobs, including the submitted or extracted text | Duration of account |
| Sign-in attempts (connecting an assistant, or choosing a plan) | Purged 14 days after they lapse; removed with the account |
| Connector access tokens (stored hashed) | Purged 30 days after they expire or are revoked; removed with the account |
| Reports about content, and records of what was removed | 3 years after the decision |
| Upload links (stored hashed), with the episode details given when each was made | Purged a day after they expire; removed with the feed or the account |
| Pending signups | Auto-expire and are purged daily |
| Account deletion confirmations | Purged daily after completion or expiry |
| Feed and episode request records | 14 days |
| Daily delivery totals | Kept; removed with the feed or the account |
| Introduction-page views and presses, with their country and device type | 400 days |
| Analytics events | 12 months (Mixpanel project setting) |
| Error and timing records | 30 days (Sentry) |
| Records of account emails sent (kind and time, no content) | Duration of account |
| Email preferences, with the wording agreed to and its confirmation or withdrawal | Duration of account, plus 3 years after withdrawal or deletion |
| The notice item's audio, and the record that the free narration ran out | Duration of account |

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
