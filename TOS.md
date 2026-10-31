# Terms of Service

**Version**: v1.12
**Effective date**: October 31, 2026

These terms govern your use of Potion (withpotion.io), an RSS feed management API for AI agents. By verifying your email during signup, either by clicking the magic link or by entering the sign-in code we email you, you accept these terms.

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

Each feed has its own address. The address is long and random, so it can't realistically be guessed, and the feed asks podcast directories not to list it, which they are not obliged to do. That makes a feed unlisted, not private. There is no password, so anyone who has the address can subscribe and listen. When Potion hosts an episode's audio, the address of that audio file contains the feed's identifier, so passing on one such address passes on the whole feed, including episodes added later. Potion does not offer a way to change a feed's address. Once an address is out, deleting the feed, and its episodes with it, is the only way to stop it working. Do not put anything in a feed that you would not want someone else to hear.

Potion also speaks the Model Context Protocol at `api.withpotion.io/mcp`, so an assistant such as ChatGPT or Claude can be connected to your account and do the same things through that connection.

There is no dashboard. The web pages Potion serves are the ones the service needs in order to work: the sign-in page you reach when connecting an assistant, the page an emailed link opens, a page where you sign in with an emailed code to choose a paid plan before paying through Stripe, a page that a link in a free feed, or on that feed's page in a browser, opens, which shows the plan that fits your show and lets you pay through Stripe without signing in, a page that emails a subscriber a link to the Stripe billing page, the pages Stripe returns you to after checkout, the public page for a shared episode (Section 8), the page a feed's address shows when you open it in a web browser, which helps you add the feed to a podcast app, and a page of links to these terms and the Privacy Policy.

---

## 3. Account Ownership and Agent-Mediated Use

Your account is identified by the email address used at signup.

- An AI agent may initiate the signup process on your behalf.
- The account owner is always the human who holds the email address.
- Ownership transfers to you the moment you verify your email, by clicking the magic link or by entering the sign-in code. That step is also your acceptance of these terms.
- You can also connect an assistant to your account over OAuth. Connecting is a sign-in: you enter your email, we email you a 6-digit code, and typing it into the sign-in page approves the connection and creates the account if you do not already have one. The connection is issued an access token with the same rights as your API key.
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

On the Free tier, Potion may add two kinds of note from Potion to the copy of your feed that podcast apps receive, and shows the same information on the page your feed's address opens in a web browser. Once you have used an hour of your free narration, the newest episode's show notes start with a line saying how much is left, with a link to a page that shows the plan that fits your show. From the same point, the page your feed's address opens in a web browser says how much free narration is left, or that it is used up, with a link to that page. When the free narration is used up, a short spoken notice from Potion appears in the feed as its own item, with the same link in its description. Potion does not change your episodes themselves, and the notes are not part of what you or your assistant see through the API or the connectors. They stop when your account moves to a paid plan, and the notice item goes away on its own after three weeks.

If a Free feed has had a new narrated episode on most days when the free narration runs out, Potion makes up to two more of its episodes anyway, so the show does not stop the next morning. These are made with the standard voices only, at the feed's usual length, and once per account. After them, narration on the Free tier stops until the plan changes.

---

## 5. Billing

- Paid subscriptions are billed monthly via Stripe.
- Subscriptions renew automatically unless cancelled.
- You can cancel at any time from the Stripe Customer Portal. Your assistant can open it for you where the connector allows it, through `POST /account/billing`, or you can enter your account's email address at `api.withpotion.io/billing` and Potion emails that address a link to it.
- No refunds are issued for partial months. If you cancel, your paid access continues until the end of the current billing period.
- If a payment fails, your account is downgraded to the Free tier. Feeds and episodes that exceed Free tier limits will not be deleted automatically, but you will be unable to create new ones until you are within Free tier limits or until you subscribe again.
- On downgrade, your included text-to-speech becomes the Free tier's. The one-time trial credit does not come back if you have already spent it.

---

## 6. Text to Speech

Potion can turn text into audio for you. You submit text, or a URL for Potion to read (Section 7), choose a voice, and Potion produces an episode from it.

- Synthesis is carried out by third-party providers acting on our behalf. The text you submit is sent to them so they can return the audio. They are named in the Privacy Policy, along with what each one receives.
- Every voice Potion offers is generated by AI, so narrated audio is synthetic speech and not a recording of a person.
- Audio Potion narrates carries machine-readable marks identifying it as AI-generated: a signed Content Credentials record and, for standard voices, an inaudible watermark. Editing or re-encoding a file can remove the record; the watermark is designed to remain.
- What is included in your tier is measured in hours of finished audio, not in characters. What counts against it is the real duration of the audio that came out.
- Standard voices draw on that allowance second for second. Premium voices draw on it at five times the rate, so an hour of premium audio spends five hours of allowance.
- The allowance is a rolling 30-day window rather than a calendar month. Free accounts have no rolling allowance, only the one-time trial credit described in Section 4. When that credit is used up, Potion tells you by email once, and the note described in Section 4 appears in your feed.
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
- Potion cannot tell whether you are allowed to have a page read aloud. Only submit text or links where copying the text and narrating it for you is allowed, either because you have permission or because the law allows it. A page being publicly reachable does not on its own mean that it is. Do not use this to get around a paywall or an access control, or to break license terms that bind you.

---

## 8. Shared Episode Pages

Every episode has a public page at `withpotion.io/e/{title words}-{code}`, for example `withpotion.io/e/morning-briefing-k7Qm2xAb9Zp3`. The URL comes back with the episode when you create it.

- The code is unguessable and is not derived from the episode id or the feed id. The words before it are the first few words of the episode's title, so anyone who sees the link sees them. If you rename the episode, its link changes to match, and the old link takes people to the new one. Links handed out before 18 October 2026, at `api.withpotion.io/e/shr_...`, keep working the same way.
- The page carries the episode's title, description, artwork and audio, and does not reveal which feed it belongs to or where that feed is served.
- The page is public. Anyone holding the link can open and play the episode without signing in, for as long as the episode exists. Sharing the link is publishing that one episode, so treat it that way.
- An episode with a future publish date is not reachable through its page until that date.
- The pages are served with a header asking search engines not to index them. Most crawlers respect that; none is obliged to.
- Deleting the episode removes the page.

---

## 9. Your Content

- You keep whatever rights you have in your content.
- To the extent you can grant them, you give 9592 Solutions UG the non-exclusive rights needed to copy, store, transmit and narrate what you submit, and to serve the resulting audio through your feed and its episode pages, only in order to provide Potion to you. That includes processing by the providers named in the Privacy Policy for that purpose.
- AI-generated content is allowed, within these terms.
- For an episode that points at audio hosted somewhere else, Potion stores the link and not the file, so whether it plays depends on that host. For narration, Potion stores the text that was submitted or extracted, alongside the job and the audio it produces.

Illegal content is not allowed. Child sexual abuse material (CSAM) in any form leads to the account being closed and a report to law enforcement.

---

## 10. Acceptable Use

Do not use Potion to:

- Violate any applicable law or regulation
- Infringe on intellectual property rights
- Get around a paywall or access control, or break license terms that bind you, including through Potion's URL reading
- Share an episode's page or audio publicly when you do not have the rights to publish it
- Upload or reference CSAM or other illegal content
- Attempt to gain unauthorized access to Potion's infrastructure
- Interfere with or degrade service for other users
- Resell or sublicense access to Potion in a way that violates these terms

We may remove content or temporarily suspend access where that is necessary and proportionate to deal with a breach of these terms. We may end your account for good cause, normally after a warning and a reasonable chance to put things right, unless the breach justifies ending it immediately. We report suspected crimes where the law requires it.

---

## 11. Reporting Illegal Content

If you think something Potion hosts is illegal, including content that infringes your copyright, email christo@withpotion.io. You do not need an account to report it. We read reports in German and English.

So that we can act on a report, please include:

- why you believe the content is illegal
- the exact address where you found it, such as the episode page link (`api.withpotion.io/e/...`) or the audio link
- your name and email address, which you may leave out if the report concerns child sexual abuse material
- a statement that you believe in good faith that the report is accurate and complete

Each report then goes through the following steps.

- We confirm that we received it.
- A person reviews every report.
- If the content is illegal or breaks these terms, we remove it. Removal covers the audio, the episode page, and the text the episode was narrated from.
- We tell you what we decided, including when we decide not to act, and how you can challenge the decision: by replying and asking us to look again, or in court.
- We tell the account holder what was removed and why, and how they can ask us to reconsider. We do not tell them who made the report unless the law requires it.

Some checks run automatically before anything is narrated, as described in Section 7: refused domains, pages that yield too little text, and robots.txt. No other decision about content is made automatically.

The same address is our point of contact for authorities, the European Commission and the European Board for Digital Services. Users can also reach us through [GitHub issues](https://github.com/withpotion/potion/issues).

---

## 12. No Service Level Agreement

Potion is provided "as is" and "as available." We do not guarantee any specific uptime, availability, or response time. We will do our best to keep the service running, but we make no SLA commitments.

---

## 13. Liability

9592 Solutions UG is liable without limitation for intentional or grossly negligent conduct, and for negligently causing death or injury to body or health.

For ordinary negligence, we are liable only if we breach an essential contractual duty, meaning a duty that has to be performed for Potion to work as agreed and that you may reasonably rely on. That liability is limited to damage that was foreseeable when the contract was made and is typical for a contract of this kind. Otherwise we are not liable for ordinary negligence.

These rules also apply to our legal representatives and to the people we use to perform the contract. They do not affect liability for fraudulently concealed defects, under a guarantee we have given, under the Product Liability Act (Produkthaftungsgesetz), or under Article 82 GDPR.

Your statutory rights are not affected, including your rights to have defects fixed, to reduce the price, to cancel, and to a refund.

---

## 14. Termination

**By you**: Stop using the API at any time. Cancel your subscription via the billing portal. You may request deletion of your account and data by emailing christo@withpotion.io.

**By us**: We may end your account as described in Section 10.

On termination, your data will be deleted within a reasonable timeframe. Content stored in R2 (uploaded and generated audio) and database records (feeds, episodes, account data, connector tokens, render jobs, and text-to-speech usage records) will be removed.

---

## 15. Changes to These Terms

We may update these terms from time to time. When we do, we will update the version number and effective date at the top of this file. Because this document lives in a public GitHub repository, you can see every change via `git log TOS.md`. Continued use of Potion after changes are posted constitutes acceptance of the updated terms. We will provide advance notice of material changes where reasonably possible.

---

## 16. Governing Law and Dispute Resolution

These terms are governed by German law, excluding conflict of law provisions.

The place of jurisdiction is Dusseldorf, Germany, to the extent permitted by law.

For disputes between businesses (B2B), the courts of Dusseldorf have exclusive jurisdiction.

For consumers in the EU: you may have the right to use alternative dispute resolution. The European Commission provides an online dispute resolution platform at [https://ec.europa.eu/consumers/odr/](https://ec.europa.eu/consumers/odr/). We are not obligated to participate in ADR proceedings, but you are entitled to use that platform.

---

## 17. Contact

For questions about these terms, data requests, or account issues:

Email: christo@withpotion.io

---

## 18. Impressum (pursuant to Section 5 TMG)

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
