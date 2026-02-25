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

## How to Deconstrain

Replace incidental prescriptive content with:
- **Pointers to resources** ("Consult X and Y, then decide based on context")
- **Open questions** ("Consider: what's your position? what are the characteristics?")
- **Generic abstractions** ("touches" not "postcards_sent")
- **Explicit permission** ("This isn't exhaustive - invent approaches that fit")
- **Principles over procedures** ("The goal is X" not "The steps are 1, 2, 3")

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
2. **Scan for constraining patterns** - concrete lists, decision logic, method-specific structures
3. **Distinguish load-bearing from incidental** - ask the user if uncertain
4. **Assess the balance** - if mostly load-bearing or factual, minimal changes may be appropriate
5. **Replace incidental constraints** with open-ended alternatives
6. **Preserve or reframe load-bearing constraints** as principles
7. **Keep factual documentation** - tools exist or don't, that's not constraining

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
