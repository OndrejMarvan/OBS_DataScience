---
tags:
  - system
---

# 📇 Anki Decks — Staged Core Vocabulary

Each deck is **deduplicated and ordered by usefulness**, then split into stages via tags.
Card 1 is `ja / já / I`. Card 2900 is specialist vocabulary. You work outward from the centre.

| File | Cards | Front → Back |
|------|-------|--------------|
| anki-polish.csv | ~2,920 | Polish → Czech + English |
| anki-german.csv | ~2,810 | German → Czech + English |
| anki-russian.csv | ~2,900 | Russian → Czech + English |

Format: `Target;Czech;English;Tags` — semicolon-separated, UTF-8.

## The stages (this is the important part)

| Tag | Cards | What it gives you |
|-----|-------|-------------------|
| `core500` | 1–500 | Pronouns, top verbs, essential nouns. **~50% of everyday speech.** |
| `core1000` | 501–1000 | Rounds out daily life. ~65% coverage. |
| `core2000` | 1001–2000 | Comfortable conversation on familiar topics. ~80% coverage. |
| `core4000` | 2001–end | Abstract, professional, specialist. ~90%+ coverage. |

**Frequency is brutally non-linear.** The first 1,000 words do more for you than the next 3,000 combined. Finish core500 before touching anything else.

## Import (Anki desktop)
1. File → Import → select the CSV
2. Separator: **semicolon** · Allow HTML: **off**
3. Map: Field 1 → Front · Field 2 → Back · Field 3 → Back (extra) · Field 4 → **Tags**
4. One deck per language

## Use without drowning
1. After import: Browse → select all → **Suspend**
2. Unsuspend `core500` only. New cards/day: **10–15**, no more.
3. Move to the next stage only when the current one is <10% mature-lapsed.
4. Topic tags are still on every card, so you can also unsuspend by theme when real life demands it (doctor's visit → unsuspend `A2_B1_Body_Extended_and_Medical`).

## Recognition vs production
These cards train **recognition** (see Polish → recall meaning). That's the right first step.
For **production** (Czech → produce Polish), which is what speaking needs:
- In Anki: use a note type with a reverse card, and enable reverse cards **only for `core500` and `core1000`**. Production drilling on 3,000 words is punishment, not study.
- Better still: production is trained by *output* — writing and speaking. See [[The Fluency Method — How to Use This Vault]].

## Per-language start points
- 🇵🇱 **Polish** — skip `core500`/`core1000` (you know them). Start at `core2000`, plus unsuspend all False-Friends-tagged cards immediately.
- 🇩🇪 **German** — start at `core500` as a reactivation sweep; you'll blitz cards you still know, and the ones you've lost will surface fast.
- 🇷🇺 **Russian** — nothing until Cyrillic is automatic. Then `core500` only, 10/day.

Regenerate anytime (e.g. after adding your own word notes): ask Claude to *"rebuild the staged Anki decks from the vault."*
