---
name: voice-calibrate
description: Iteratively refine a personal voice playbook by generating realistic writing scenarios, drafting per current rules, collecting structured feedback, and updating the playbook with learnings. Use when user says "voice-calibrate", "calibrate my voice", "voice drill", or wants to practice/refine writing voice.
---

# Voice Calibration

Drill for distilling authentic voice. Generates scenarios, drafts per playbook, collects feedback, updates playbook.

## Prerequisites

1. **Locate or create voice playbook.** Look for a voice playbook skill (e.g. `voice-playbook/SKILL.md`) in the user's skills directory. If none exists, create one from the template below before proceeding.
2. Read the voice playbook to load current rules.
3. Parse invocation args (see below).

### Voice Playbook Bootstrap Template

If the user has no voice playbook yet, create `voice-playbook/SKILL.md` with this starter content and tell the user it will be filled in through calibration rounds:

~~~markdown
---
name: voice-playbook
description: Write in the user's authentic voice. Communication preferences, patterns, and anti-patterns for public content. Use when drafting user-facing text (Reddit, HN, X, emails, landing pages).
---

# Voice Playbook

Captures communication style, preferences, and learnings. Updated iteratively via calibration rounds.

## Principles

*(Empty - will be populated through calibration)*

## Patterns That Work

### Titles
*(To be discovered)*

### Body Structure
*(To be discovered)*

## Anti-Patterns

*(To be discovered through calibration rounds)*

## Platform Notes

*(To be discovered)*

## Examples & Deltas

*(Calibration rounds will add concrete before/after examples here)*

## Learnings Log

*(Calibration rounds will append dated entries here)*

---

*Last updated: (never)*
~~~

## Invocation

`/voice-calibrate` - start calibration. Args:
- No args: 1 round, random scenario
- Number (e.g. `5`, `10`): run N rounds back-to-back
- Platform name (e.g. `reddit`, `hn`, `email`): focus on that platform
- Both (e.g. `reddit 5`): N rounds on that platform

## Scenario Dimensions

Pick one from each. Favor combinations not yet covered in the playbook's Examples & Deltas section.

**Platform**: Reddit comment, Reddit post, X tweet, X reply, HN Show post, HN comment, cold email, follow-up email, landing page copy, WhatsApp message

**Context**: Promoting own product, sharing genuine insight, answering someone's question, cold outreach, disagreeing respectfully, sharing news/update, thanking someone

**Tone**: Builder-to-builder, helpful stranger, technical peer, casual, professional

**Length**: One-liner, short paragraph, multi-paragraph

## Round Procedure

### Step 1: Generate Scenario

Create a fictional-but-realistic scenario with enough detail to draft against. Include:
- The platform and specific subreddit/thread/situation
- What triggered the writing (a post seen, a question asked, a product to share)
- The audience and their likely knowledge level
- Any constraints (character limits, community norms)

**Example**: "You're replying to a Reddit post in r/selfhosted where someone asks about monitoring website changes. They've tried Visualping and found it unreliable. 15 upvotes, 8 comments so far. Your product (a web monitoring tool) is directly relevant."

Present the scenario and confirm the user wants to proceed (or let them tweak it).

### Step 2: Draft Per Playbook

Write the draft as the user would. Then show an **active checklist** of playbook rules:

```
## Playbook Checklist

**Principles applied:**
- [x] Authenticity over polish - used real origin story
- [x] Reader context matters - no assumed competitor knowledge in hook
- [ ] Show technical depth - N/A for this format

**Anti-patterns checked:**
- [x] No pronoun dropping ("I built" not "Built")
- [x] No false stakes (not claiming to monitor something I don't)
- [x] No marketing speak
- [x] No over-brevity
- [ ] Too slick phrasing - flagging "X" as potentially workshopped

**Platform rules applied:**
- [x] Builder disclosure (r/selfhosted = builder-friendly)
```

This makes the rules visible so feedback is grounded in specifics. For a fresh playbook with empty sections, the checklist will be short - that's fine, it grows as rules are discovered.

### Step 3: Collect Feedback

Use AskUserQuestion with these questions:

**Question 1** (single-select): "Does this sound like you?"
- Options: "1 - Not at all", "2 - Somewhat off", "3 - Passable", "4 - Pretty close", "5 - Nailed it"

**Question 2** (single-select): "What feels off?" with options:
- "Too formal/stiff"
- "Too casual/breezy"
- "Too salesy/marketing"
- "Too verbose"
- "Nothing major"

Then follow up with free-text for specifics:

**Question 3** (single-select): "Any specific words or phrases that are wrong?"
- "Yes, let me describe"
- "No, it's fine at the word level"

**Question 4** (single-select): "Did you spot any anti-pattern violations?"
- "Pronoun dropping"
- "False stakes"
- "Too slick phrasing"
- "Over-brevity"
- "None detected"

### Step 4: Update Playbook (Conditional)

Only update if feedback reveals a pattern worth capturing. Not every round produces a learning.

**When to update**: New anti-pattern discovered, existing rule needs refinement, new platform insight, phrasing correction that generalizes.

**When NOT to update**: Feedback is scenario-specific, rating was 4-5 with no structural notes, correction is one-off word choice.

**If updating**, edit the voice playbook directly:
- Add to appropriate section (Principles, Anti-Patterns, Platform Notes, etc.)
- Add a Learnings Log entry:

```markdown
### YYYY-MM-DD - [Short Title]

**Context**: [Calibration round: platform, scenario type]

**What happened**: [What the draft got wrong]

**Learning**: [The generalizable insight]

**Action**: [What was added/changed in the playbook]
```

- Update `*Last updated:*` date at bottom of playbook

### Step 5: Next Round or Wrap Up

If more rounds remain, proceed to Step 1 with a new scenario (vary dimensions from previous rounds).

If done, summarize the session:
- Rounds completed
- Average score
- Playbook changes made (if any)
- Dimensions still uncovered (suggest for next session)

## Valid Outcomes

- **Playbook updated** - Feedback revealed generalizable patterns
- **No update needed** - Drafts were on-target, no new patterns emerged
- **Session cut short** - User found enough after fewer rounds than planned

All three are fine. Don't force playbook updates just to show progress.
