# Terms of Service

**Version**: v1.0
**Effective date**: February 23, 2026

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

Potion is an API. There is no website or dashboard. You (or an AI agent acting on your behalf) call API endpoints to create RSS feeds, upload audio, and manage episodes. Humans subscribe to those feeds in podcast apps or feed readers.

---

## 3. Account Ownership and Agent-Mediated Use

Your account is identified by the email address used at signup.

- An AI agent may initiate the signup process on your behalf.
- The account owner is always the human who holds the email address.
- Ownership transfers to you the moment you click the magic link to verify your email. That click is also your acceptance of these terms.
- You are responsible for all activity that occurs under your API key, whether that activity is initiated by you directly or by an agent acting on your behalf.
- Keep your API key confidential. If you believe your key has been compromised, regenerate it immediately via `POST /account/api-key/regenerate`.

---

## 4. Service Tiers and Limits

Potion offers two tiers:

**Free**: No charge. Includes a limited number of feeds, episodes, storage, and per-file upload size.

**Plus**: $5 per month, billed via Stripe. Includes higher limits across all dimensions.

Current limits for each tier are shown at `GET /account` and in the API documentation at `api.withpotion.io/docs`. We may adjust limits over time; changes to limits for existing users will be communicated in advance.

---

## 5. Billing

- Plus subscriptions are billed monthly via Stripe.
- Subscriptions renew automatically unless cancelled.
- You can cancel at any time via `POST /account/billing`, which opens the Stripe Customer Portal.
- No refunds are issued for partial months. If you cancel, your Plus access continues until the end of the current billing period.
- If a payment fails, your account is downgraded to the Free tier. Feeds and episodes that exceed Free tier limits will not be deleted automatically, but you will be unable to create new ones until you are within Free tier limits or until you re-subscribe to Plus.

---

## 6. Your Content

- You retain ownership of all content you upload or reference through Potion.
- By uploading content, you grant 9592 Solutions UG a limited, non-exclusive license to store, transmit, and serve that content solely for the purpose of operating Potion on your behalf.
- AI-generated audio is explicitly permitted.
- External URL episodes are stored as references only. Potion does not download, validate, or cache external audio files. You are responsible for the availability and legality of externally referenced content.

You are responsible for ensuring your content complies with applicable law. Content that is illegal, infringing, or harmful is not permitted. Zero tolerance for child sexual abuse material (CSAM) in any form. Violations will result in immediate account termination and referral to law enforcement.

---

## 7. Acceptable Use

Do not use Potion to:

- Violate any applicable law or regulation
- Infringe on intellectual property rights
- Upload or reference CSAM or other illegal content
- Attempt to gain unauthorized access to Potion's infrastructure
- Interfere with or degrade service for other users
- Resell or sublicense access to Potion in a way that violates these terms

We reserve the right to remove content or suspend accounts that violate these rules.

---

## 8. No Service Level Agreement

Potion is provided "as is" and "as available." We do not guarantee any specific uptime, availability, or response time. We will do our best to keep the service running, but we make no SLA commitments.

---

## 9. Limitation of Liability

To the maximum extent permitted by applicable law, 9592 Solutions UG's total liability to you for any claim arising out of or related to these terms or your use of Potion is limited to the greater of:

(a) the fees you paid to Potion in the three months immediately preceding the claim, or
(b) EUR 50.

Note: German law does not permit exclusion of liability for death or bodily injury caused by negligence, or for damages caused by intentional misconduct or gross negligence (see BGB Section 309 No. 7). This limitation does not apply to such claims.

We are not liable for indirect, incidental, consequential, or punitive damages.

---

## 10. Termination

**By you**: Stop using the API at any time. Cancel your Plus subscription via the billing portal. You may request deletion of your account and data by emailing christo@withpotion.io.

**By us**: We may suspend or terminate your account if you violate these terms. We will give reasonable notice where practical, but reserve the right to act immediately for serious violations.

On termination, your data will be deleted within a reasonable timeframe. Content stored in R2 (uploaded audio) and database records (feeds, episodes, account data) will be removed.

---

## 11. Changes to These Terms

We may update these terms from time to time. When we do, we will update the version number and effective date at the top of this file. Because this document lives in a public GitHub repository, you can see every change via `git log TOS.md`. Continued use of Potion after changes are posted constitutes acceptance of the updated terms. We will provide advance notice of material changes where reasonably possible.

---

## 12. Governing Law and Dispute Resolution

These terms are governed by German law, excluding conflict of law provisions.

The place of jurisdiction is Dusseldorf, Germany, to the extent permitted by law.

For disputes between businesses (B2B), the courts of Dusseldorf have exclusive jurisdiction.

For consumers in the EU: you may have the right to use alternative dispute resolution. The European Commission provides an online dispute resolution platform at [https://ec.europa.eu/consumers/odr/](https://ec.europa.eu/consumers/odr/). We are not obligated to participate in ADR proceedings, but you are entitled to use that platform.

---

## 13. Contact

For questions about these terms, data requests, or account issues:

Email: christo@withpotion.io

---

## 14. Impressum (pursuant to Section 5 TMG)

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
