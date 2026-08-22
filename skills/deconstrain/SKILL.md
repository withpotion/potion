---
name: deconstrain
description: |
  Identify and remove patterns that constrain future thinking while preserving what works. Use when:
  - User says "deconstrain", "remove over-indexing", "keep it greenfield", "don't limit future thinking"
  - Reviewing artifacts (docs, configs, prompts, schemas) that might cause over-indexing on specific approaches
  - Refactoring to be more open-ended
  - User notices their artifacts are causing narrow thinking or missed alternatives
---

# Deconstrain

Artifacts shape how future agents think. Concrete lists become checklists. Checklists become blinders. Decision matrices become the only logic considered.

This is a prompt-level instance of the Bitter Lesson: encoded human knowledge caps what systems can discover. Chess heuristics constrained what AlphaZero could find. Option lists constrain what future agents can consider.

**Related framings (and where they fall short):**
- **Bitter Lesson Engineering** (Daniel Miessler): specify the *what*, not the *how*. Constraints don't only cap what an agent considers — they *decay*: a procedure tuned for a weaker model actively degrades a stronger one. "The smarter AI gets, the more antiquated your instructions become" — at some point they make the AI stupider, not smarter.
- **"The model eats the scaffolding"** (Logan Kilpatrick): workarounds for a model's current limits get absorbed into the next model and become dead weight. Scaffolding has a shelf life.
- **Deconstrain's edge over both:** the load-bearing-vs-incidental distinction. Those framings trend absolutist ("never prescribe how"); that would strip the constraints this skill deliberately preserves. Keep the decay insight, not the absolutism.

## The Phenomenon

When artifacts contain:
- **Concrete option lists** ("Option A, Option B, Option C")
- **Decision matrices** ("If X then do Y")
- **Method-specific structures** (postcards_sent, emails_sent)
- **Prescribed workflows** ("Step 1: Do X, Step 2: Do Y")
- **Exhaustive checklists** with specific items

Future agents will:
- Only consider the listed options
- Follow the prescribed logic without questioning it
- Track only what's structured for tracking
- Miss creative alternatives that fit better
- Treat the artifact as THE answer rather than A starting point

## What to Look For

**Constraining patterns:**
- Numbered/lettered option lists
- Tables mapping conditions to actions
- Fields that imply a closed set of values
- "When to use X vs Y" decision guides
- Method-specific naming (implies the method is fixed)
- Architecture showing specific tools as core components
- "The workflow is..." statements
- Conclusion-first ordering (recommendation before reasoning, answer before analysis)

**The test:** Would an agent reading this feel free to invent a completely different approach? Or would they feel they should pick from the presented options?

## Load-Bearing vs Incidental Constraints

Not every constraint should be removed. Some are load-bearing.

**Incidental constraints** (safe to deconstrain):
- Examples that became implicit requirements
- Defaults that hardened into rules
- One option written as if it were the only option
- Specifics added for illustration, not prescription

**Load-bearing constraints** (preserve these):
- Hard requirements (legal, technical, safety)
- Lessons learned from failures ("we tried X, it broke because Y")
- Essential domain constraints that would cause real problems if ignored
- Intentional guardrails with reasons behind them

**How to tell the difference:**
- Does removing this risk repeating a past mistake?
- Is this specific because it HAS to be, or because someone just wrote it that way?
- Would an expert in this domain object to removing it?

**When uncertain:** Use AskUserQuestion. Present the constraint, explain why it might be load-bearing or incidental, and ask which it is. Don't guess on ambiguous cases - the user knows context you don't.

## What to Preserve

Before removing anything, identify what the artifact does well:
- Clarity that would be lost if you over-abstract
- Real examples that ground abstract concepts
- Hard-won insights encoded as specifics
- Structure that genuinely helps (vs structure that constrains)

Deconstraining isn't about stripping everything down. It's about opening creative space while keeping what works.

## Solution Space Intent <!-- added: 2026-03-25 -->

Before scanning for patterns, ask: **what is this artifact trying to do to the solution space?**

Artifacts relate to the solution space in three ways:

- **Constrain** - narrow it. Guardrails, requirements, standards, "don't do X" rules. Constraining is sometimes the whole point. The question is whether each constraint is load-bearing or incidental (next section's focus).

- **Document** - map it without changing it. References, inventories, architecture docs, "here's what exists" lists. Constraining patterns here are perception bugs - the reader mistakes the map for the territory. "These are the three deployment options" reads as "there are only three options." Fix is usually completeness cues or explicit framing ("known options include..."), not removal.

- **Expand or shift** - open it up, reposition it, or reshape it. Brainstorming prompts, strategy pivots, principles, exploration guidance. Constraining patterns here are the most damaging because they undermine the artifact's own purpose. A brainstorming doc that lists five ideas becomes a multiple-choice quiz. A strategy pivot that over-specifies the new direction trades one box for another. Deconstrain aggressively.

**The calibration:** An artifact meant to expand that accidentally constrains needs aggressive deconstraining. An artifact meant to document that accidentally constrains needs framing fixes. An artifact meant to constrain needs validation (load-bearing or incidental?), not reflexive loosening.

Most artifacts blend these intents - a strategy doc might constrain (guardrails from past failures), document (current landscape), and expand (new directions) in different sections. Assess per-section, not per-artifact.

**The temporal axis** <!-- added: 2026-06-08 -->: load-bearing vs incidental isn't fixed — it drifts as the model improves. A constraint that was load-bearing for a weaker model (a step-by-step procedure that compensated for what it couldn't figure out) can become incidental, then actively harmful, once a stronger model could derive the same thing better on its own. So when re-touching an artifact, don't assume past constraints are still earning their place — re-ask "is this still load-bearing for *this* model?" The decay direction is one-way: prescriptive how-to rots fastest, context about who/what/why ages best.

## How to Deconstrain

Replace incidental prescriptive content with:
- **Pointers to resources** ("Consult X and Y, then decide based on context")
- **Open questions** ("Consider: what's your position? what are the characteristics?")
- **Generic abstractions** ("touches" not "postcards_sent")
- **Explicit permission** ("This isn't exhaustive - invent approaches that fit")
- **Principles over procedures** ("The goal is X" not "The steps are 1, 2, 3")
- **Reasoning before conclusions** - present context and analysis before recommendations, so readers form their own view before encountering yours

Reframe load-bearing constraints as principles rather than prescriptions when possible. "Never do X" becomes "We learned that X causes Y, so avoid it."

## Anti-Pattern: Over-Genericizing <!-- added: 2026-02-12 -->

Deconstraining is not stripping all specifics. Listing available tools or activity types (emails, calls, DMs) isn't constraining - it's useful context. What constrains is implying those are the ONLY options or that one is the default. Adding "(not exhaustive)" or framing as "for reference" preserves the useful specifics while opening the space.

## Anti-Pattern: Template Format Mimicry <!-- added: 2026-02-12 -->

When writing templates or examples, agents reproduce the exact shape - same number of bullets, same paragraph length, same section structure. If an ICP template shows one paragraph and four qualifying signals, every niche will get one paragraph and four qualifying signals.

Fix: Describe what kinds of things to include rather than showing a sized example. "Describe the person, the organization, and the context" invites varied responses. A filled-in example paragraph invites copy-paste-and-tweak.

## Anti-Pattern: Reference Implementation Anchoring <!-- added: 2026-02-14 -->

Pointing to a concrete file as a "reference implementation" or "template to consult" imports all of its incidental choices. An agent told to consult `~/projects/foo/api/handler.js` will read the entire file and absorb its form fields, variable names, error handling, and response format as implicit requirements - even if only the high-level pattern was intended.

This isn't always wrong. Sometimes the specifics ARE the point (deploy configs, shared utilities, exact protocol implementations). The problem is doing it unintentionally when you meant to document a reusable pattern.

**Deliberate choice:** "Does the next agent need to match these specifics, or reason from the pattern?" If the latter, describe what the pattern does and why. If the former, point to the file.

## Anti-Pattern: Negative Anchoring

When deconstraining, avoid mentioning what triggered it. Saying "don't focus on X" or "X is just one example" still anchors the reader on X. They'll either over-focus on it or consciously avoid it - both are distortion.

**Bad:**
```markdown
Test your demos thoroughly. The bugs you'll find are unpredictable -
don't fixate on scroll links.
```

**Good:**
```markdown
Test your demos thoroughly.
```

The absence of specifics IS the deconstraint. State only the positive principle. Don't explain what NOT to do. Don't hint at what prompted the guidance.

**The self-referential variant** <!-- added: 2026-07-21 -->: describing a *model-behavior* failure mode ("models do X when they sense Y") in always-loaded guidance is negative anchoring aimed at the reader itself — a standing description of the reader's own disposition primes that disposition every session. Keep the positive behavioral rule in the always-read text; park the phenomenon's name, evidence, and psychology in a deliberately-read provenance doc the rule points to. (Forged on orchestrate's "context anxiety" paragraph, 2026-07-21 — reframed to "worker prompts talk about the task, never about token budgets"; evidence lives in the research dir it cites.)

**The situational-reason variant** <!-- added: 2026-08-11 -->: a *reason* recorded in a surface that gets injected into every future session — a project state block, a startup hook, a standing note — installs a disposition, where the *gate* alone would have installed a behavior. "Paused because this was expensive" teaches the reader to weigh cost; "paused until <date>, resume when <condition>" teaches it to check a date. Both are true; only one generalizes. And it does generalize: a reason attached to one arc becomes the frame the reader applies to *unrelated* work it meets in the same place, because an injected block reads as ambient truth rather than as a scoped note. So record what re-entry needs — when it lifts, what must be true first, who owns it — and let the reason live where it reads as provenance (a dated quote, a chronicle) rather than as the frame. Costs, scarcity, past failures, and "we did it this way because" are the usual carriers.

## Anti-Pattern: The Fallback Ladder <!-- added: 2026-07-07 -->

An ordered "try X, then Y, then Z" sequence — an escalation ladder, a tiered fallback, a "cheapest-first" list of options — is a procedure wearing the costume of *optionality*. It slips past the "prescribed workflow" flag because it reads as a menu, not a rigid Step 1→2→3 — but it constrains twice:

1. **It anchors to the listed rungs and their order.** The reader stops considering options off the ladder and treats the ordering as the logic even when the situation wants a different pick.
2. **It smuggles in a stop criterion — "stop at the first rung that works."** That quietly converts the *goal* (solve it well / get what the task actually needs) into a *process* (a step ran without erroring) — the actually-trying proxy-satisfaction trap. The first tool returns *something* thin, so the reader settles there and never reaches what the task required.

Fix: present the options as an **inventory to select from against the outcome**, not a sequence to walk. Say what each is good for, state the real bar (the result the task needs, not a step that didn't throw), and let the reader pick — including things not on the list. A cost-ordering can survive as a light instinct ("don't reach for the heavy tool when a cheap one gets it") but never as a stop condition. Sibling of actually-trying's milestone-as-endpoint — here the milestone is "a fallback step succeeded."

## Examples

**Constraining:**
```markdown
## Outreach Channels

Option A: Postcards - when physical offices exist
Option B: LinkedIn DMs - when prospects are active online
Option C: Email - when testing quickly
```

**Deconstrained:**
```markdown
## Outreach Execution

Consult expert perspectives, assess your position and the context, then choose an approach.
Document your rationale.
```

---

**Constraining:**
```yaml
postcards_sent: 0
linkedin_dms_sent: 0
emails_sent: 0
```

**Deconstrained:**
```yaml
outreach_touches: 0  # Track however makes sense for chosen approach
```

---

**Constraining:**
```markdown
| Factor | Favors Postcards | Favors LinkedIn |
|--------|------------------|-----------------|
| Has offices | ✅ | - |
| Active online | - | ✅ |
```

**Deconstrained:**
```markdown
Consider:
- Where do these people spend attention?
- What's your current position with them?
- What are you trying to learn?
```

---

**Constraining:** <!-- added: 2026-03-18 -->
```markdown
## Anti-metrics (do NOT optimize)
- DAU/MAU
- session length
- streak length
- retention
```

**Deconstrained:**
```markdown
Any metric is fine to track. The question is what you'd change the product
to move it. If the answer involves shame, guilt, manufactured urgency, or
engagement tricks, don't do it. If the answer involves making the product
genuinely better, do it.
```

The label "anti-metric" itself was doing the constraining - it created a binary (good metrics vs bad metrics) that prevented nuanced use of informative signals. A product with strong values can track streak length without adding streak shame. The constraint belongs on the action, not the measurement.

---

---

**Constraining (LLM prompts):** <!-- added: 2026-04-14 -->
```
Title: 2-5 words.
Subtitle: 1-2 sentences.
Summary: 1-2 sentences describing...
```

**Deconstrained:**
```
Title: short or very short, used as a heading in emails and dashboards,
       should read as a noun phrase not a sentence fragment that trails off.
Subtitle: natural length is typically a sentence or two; write what the
          topic needs, no more.
Summary: the headline fact in an email - what the reader needs to see first.
```

Numeric word/char limits in LLM prompts cause truncation mid-sentence: the model starts writing, notices it's approaching the limit, and stops awkwardly (e.g., "The movie Avatar 2 (Avatar: The Way of Water) has" - trailing "has" because the model counted words as it went). Purpose-based framing ("used as a heading", "the headline fact") lets the model pick natural length for the context. Same deconstrain principle as option lists: describe the goal, not the exact shape.

---

**Load-bearing (preserve, but reframe):**
```markdown
## IMPORTANT: Never use option C

Option C seems faster but causes data corruption under load.
```

**Reframed as principle:**
```markdown
## Known Failure Mode

Approaches that skip validation may corrupt data under load.
Whatever method you choose, ensure it handles concurrent writes safely.
```

## When Deconstraining

1. **Identify what the artifact does well** - don't lose valuable clarity or hard-won insights
2. **Identify solution space intent** - is each section trying to constrain, document, or expand? This calibrates everything downstream
3. **Scan for constraining patterns** - concrete lists, decision logic, method-specific structures
4. **Distinguish load-bearing from incidental** - ask the user if uncertain
5. **Assess the balance** - if mostly load-bearing or factual, minimal changes may be appropriate
6. **Replace incidental constraints** with open-ended alternatives
7. **Preserve or reframe load-bearing constraints** as principles
8. **Keep factual documentation** - tools exist or don't, that's not constraining

The goal isn't to delete useful information. It's to present it in a way that invites thinking rather than following.

## Valid Outcomes

Not every artifact needs significant deconstraining. Valid conclusions include:

**"Minimal changes needed"** - When the artifact:
- Documents a finite system with defined mechanisms (API docs, architecture references)
- Contains mostly load-bearing constraints from real lessons learned
- Is factual documentation where specificity is the point
- Already uses open-ended framing ("consider", "depending on context")

**"Targeted changes only"** - When:
- A few incidental constraints exist within otherwise solid documentation
- Some → arrows or decision matrices could be softened without losing value
- Presentation implies rules but content is actually guidance

**"Significant deconstraining needed"** - When:
- Strategy docs present one approach as THE approach
- Examples have hardened into implicit requirements
- Decision matrices eliminate creative thinking
- The artifact would make future agents feel they must pick from listed options

Report your assessment honestly. Deconstraining for its own sake damages useful artifacts.
