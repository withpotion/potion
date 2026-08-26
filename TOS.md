# Terms of Service

**Version**: v1.3
**Effective date**: August 26, 2026

These terms govern your use of Potion (withpotion.io), an RSS feed management API for AI agents. By clicking the magic link to verify your email during signup, you accept these terms.

---

## 1. Who We Are

Potion is operated by:

9592 Solutions UG (haftungsbeschrankt)
Fahrstr. 217
40221 Dusseldorf, Germany

Managing Director: Christo Wilken
Email: christo@withpotion.io
Commercial Register: Amtsgericht Dusseldorf, HRB 287814
VAT ID: DE364316497

---

## 2. What Potion Is

Potion is an API. You (or an AI agent acting on your behalf) call API endpoints to create RSS feeds, upload or generate audio, and manage episodes. Humans subscribe to those feeds in podcast apps or feed readers.

Potion also speaks the Model Context Protocol at `api.withpotion.io/mcp`, so an assistant such as ChatGPT or Claude can be connected to your account and do the same things through that connection.

There is no dashboard. The web pages Potion serves are the ones the service needs in order to work: the sign-in page you reach when connecting an assistant, the page an emailed link opens, the pages Stripe returns you to after checkout, and the public page for a shared episode (Section 8).

---

## 3. Account Ownership and Agent-Mediated Use

Your account is identified by the email address used at signup.

- An AI agent may initiate the signup process on your behalf.
- The account owner is always the human who holds the email address.
- Ownership transfers to you the moment you click the magic link to verify your email. That click is also your acceptance of these terms.
- You can also connect an assistant to your account over OAuth. Connecting is a sign-in: you enter your email, we send you a link, and clicking it approves the connection and creates the account if you do not already have one. The connection is issued an access token with the same rights as your API key.
- You are responsible for all activity that occurs under any credential issued for your account, whether an API key or a connector token, and whether the activity is initiated by you directly or by an agent acting on your behalf.
- Keep your API key confidential. If you believe your key has been compromised, regenerate it immediately via `POST /account/api-key/regenerate`. Regenerating the key does not end existing connector sessions; connector tokens expire on their own, and deleting your account removes them.

---

## 4. Service Tiers and Limits

Potion offers three tiers:

**Free**: No charge. Includes a limited number of feeds, episodes, storage, and per-file upload size, plus a one-time credit for text-to-speech that does not recharge once it is spent.

**Plus**: A paid monthly subscription, billed via Stripe. Higher limits across all dimensions, and an amount of text-to-speech included every 30 days.

**Pro**: A more expensive monthly subscription, also billed via Stripe. Higher limits again and more included text-to-speech. Pro includes everything Plus includes.

Limits apply across five dimensions: number of feeds, number of episodes, total stored bytes, size of a single upload, and hours of text-to-speech (Section 6).

The current prices are shown at `GET /plans` and at Stripe Checkout before you pay. Current limits for each tier are shown at `GET /account` and in the API documentation at `api.withpotion.io/docs`. We may adjust prices and limits over time; changes to prices or limits for existing users will be communicated in advance.

When you reach a limit, the request is refused and the response says which limit you hit. Nothing is billed beyond your subscription; there is no overage charge on any tier.

---

## 5. Billing

- Paid subscriptions are billed monthly via Stripe.
- Subscriptions renew automatically unless cancelled.
- You can cancel at any time via `POST /account/billing`, which opens the Stripe Customer Portal.
- No refunds are issued for partial months. If you cancel, your paid access continues until the end of the current billing period.
- If a payment fails, your account is downgraded to the Free tier. Feeds and episodes that exceed Free tier limits will not be deleted automatically, but you will be unable to create new ones until you are within Free tier limits or until you subscribe again.
- On downgrade, your included text-to-speech becomes the Free tier's. The one-time trial credit does not come back if you have already spent it.

---

## 6. Text to Speech

Potion can turn text into audio for you. You submit text, or a URL for Potion to read (Section 7), choose a voice, and Potion produces an episode from it.

- Synthesis is carried out by third-party providers acting on our behalf. The text you submit is sent to them so they can return the audio. They are named in the Privacy Policy, along with what each one receives.
- What is included in your tier is measured in hours of finished audio, not in characters. What counts against it is the real duration of the audio that came out.
- Standard voices draw on that allowance second for second. Premium voices draw on it at five times the rate, so an hour of premium audio spends five hours of allowance.
- The allowance is a rolling 30-day window rather than a calendar month. Free accounts have no rolling allowance, only the one-time trial credit described in Section 4.
- When the allowance is exhausted, synthesis stops until it refills. There is no overage billing. The error you get back says when the next refill happens.
- Requesting audio and receiving it are separate steps, because producing a long episode takes minutes. Potion returns a job you can check on, and the allowance is charged when the audio exists.
- Audio you generate elsewhere and upload is unaffected by any of this. It never counts against text-to-speech, only against storage.
- Audio Potion produces for you is stored the way an upload is, counts against your storage limit, and is yours on the terms in Section 9.

---

## 7. Reading Articles from a URL

Potion can fetch a web page you point it at and extract its main text, so that text can be narrated.

- Potion fetches only what is served publicly. It does not sign in, submit forms, or use paywall-bypass services. It identifies itself as `PotionBot` and honors robots.txt.
- Some domains are refused outright, either because they exist to bypass paywalls or because their articles sit behind a subscription. A refused page is refused with a reason you can read.
- Pages that yield very little text are refused rather than narrated. That is what a paywall stub, a bot check, or a page that assembles itself in the browser looks like from the outside.
- Reading and narrating are separate steps. Potion tells you how much text it extracted and roughly how long it would run as audio, and spends nothing from your allowance until you ask it to go ahead.
- Potion cannot know what rights you hold in a page you point it at. You are responsible for having the right to have that content read aloud for you, and for not using this to get around a paywall, a license, or an access control. If you are unsure, submit the text yourself instead of a URL.

---

## 8. Shared Episode Pages

Every episode has a public page at `api.withpotion.io/e/{token}`. The URL comes back with the episode when you create it.

- The token is unguessable and is not derived from the episode id or the feed id. The page carries the episode's title, description, artwork and audio, and does not reveal which feed it belongs to or where that feed is served.
- The page is public. Anyone holding the link can open and play the episode without signing in, for as long as the episode exists. Sharing the link is publishing that one episode, so treat it that way.
- An episode with a future publish date is not reachable through its page until that date.
- The pages are served with a header asking search engines not to index them. Most crawlers respect that; none is obliged to.
- Deleting the episode removes the page.

---

## 9. Your Content

- You retain ownership of all content you upload, generate through Potion, or reference through Potion.
- By uploading content, submitting text for narration, or pointing Potion at a URL, you grant 9592 Solutions UG a limited, non-exclusive license to store, transmit, and serve that content, and to pass it to the providers named in the Privacy Policy, solely for the purpose of operating Potion on your behalf.
- AI-generated audio is explicitly permitted, whether you produce it elsewhere or Potion produces it for you.
- External URL episodes are stored as references only. Potion does not download, validate, or cache external audio files. You are responsible for the availability and legality of externally referenced content.

You are responsible for ensuring your content complies with applicable law. Content that is illegal, infringing, or harmful is not permitted. Zero tolerance for child sexual abuse material (CSAM) in any form. Violations will result in immediate account termination and referral to law enforcement.

---

## 10. Acceptable Use

Do not use Potion to:

- Violate any applicable law or regulation
- Infringe on intellectual property rights
- Get around a paywall, license, or access control, including by pointing Potion's URL reading at content you are not entitled to
- Upload or reference CSAM or other illegal content
- Attempt to gain unauthorized access to Potion's infrastructure
- Interfere with or degrade service for other users
- Resell or sublicense access to Potion in a way that violates these terms

We reserve the right to remove content or suspend accounts that violate these rules.

---

## 11. No Service Level Agreement

Potion is provided "as is" and "as available." We do not guarantee any specific uptime, availability, or response time. We will do our best to keep the service running, but we make no SLA commitments.

---

## 12. Limitation of Liability

To the maximum extent permitted by applicable law, 9592 Solutions UG's total liability to you for any claim arising out of or related to these terms or your use of Potion is limited to the greater of:

(a) the fees you paid to Potion in the three months immediately preceding the claim, or
(b) EUR 50.

Note: German law does not permit exclusion of liability for death or bodily injury caused by negligence, or for damages caused by intentional misconduct or gross negligence (see BGB Section 309 No. 7). This limitation does not apply to such claims.

We are not liable for indirect, incidental, consequential, or punitive damages.

---

## 13. Termination

**By you**: Stop using the API at any time. Cancel your subscription via the billing portal. You may request deletion of your account and data by emailing christo@withpotion.io.

**By us**: We may suspend or terminate your account if you violate these terms. We will give reasonable notice where practical, but reserve the right to act immediately for serious violations.

On termination, your data will be deleted within a reasonable timeframe. Content stored in R2 (uploaded and generated audio) and database records (feeds, episodes, account data, connector tokens, render jobs, and text-to-speech usage records) will be removed.

---

## 14. Changes to These Terms

We may update these terms from time to time. When we do, we will update the version number and effective date at the top of this file. Because this document lives in a public GitHub repository, you can see every change via `git log TOS.md`. Continued use of Potion after changes are posted constitutes acceptance of the updated terms. We will provide advance notice of material changes where reasonably possible.

---

## 15. Governing Law and Dispute Resolution

These terms are governed by German law, excluding conflict of law provisions.

The place of jurisdiction is Dusseldorf, Germany, to the extent permitted by law.

For disputes between businesses (B2B), the courts of Dusseldorf have exclusive jurisdiction.

For consumers in the EU: you may have the right to use alternative dispute resolution. The European Commission provides an online dispute resolution platform at [https://ec.europa.eu/consumers/odr/](https://ec.europa.eu/consumers/odr/). We are not obligated to participate in ADR proceedings, but you are entitled to use that platform.

---

## 16. Contact

For questions about these terms, data requests, or account issues:

Email: christo@withpotion.io

---

## 17. Impressum (pursuant to Section 5 TMG)

**Angaben gemass Section 5 TMG:**

9592 Solutions UG (haftungsbeschrankt)
Fahrstr. 217
40221 Dusseldorf
Germany

Vertreten durch: Christo Wilken
E-Mail: christo@withpotion.io

**Registereintrag:**
Eintragung im Handelsregister.
Registergericht: Amtsgericht Dusseldorf
Registernummer: HRB 287814

**Umsatzsteuer-ID:**
DE364316497

**Verantwortlich fur den Inhalt nach Section 55 Abs. 2 RStV:**
Christo Wilken, Fahrstr. 217, 40221 Dusseldorf, Germany
