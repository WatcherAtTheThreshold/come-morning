# Milestone 0 — Does the upgrade feel good?

**Goal:** answer one question before building anything else. When the player hands
over goods and the stall improves overnight, is that satisfying?

If it is, everything else in this game is worth building. If it isn't, no amount of
minigames, dialogue, or town-building will rescue it. So this milestone deliberately
contains almost nothing.

**Scope:** one stall, one resource, one handover, three visual tiers.
**Not in scope:** a town, a house, a second Kithrin, currency, UI, dialogue, saving.

---

## Build order

The order matters. Each step is a checkpoint that can kill or confirm the idea
cheaply.

### 1. Model tier 2 first, in Blender

Build the *finished* stall first — the one with the sign, the flowerbox, the good
roof. Then subtract from it to get tier 1, then tier 0.

Building forward from a crate produces three objects that don't share a silhouette,
and the upgrade reads as a replacement rather than growth. Working backward
guarantees the kit fits and surfaces sizing problems immediately.

All three tiers share the same footprint and the same anchor point.

### 2. A Godot scene with the stall and nothing else

No player, no ground plane beyond a placeholder, no camera movement. Number keys
1/2/3 swap the tier.

Look at it. This is the checkpoint. Does watching it improve feel good?

### 3. Solve the transition

An instant mesh swap reads as a bug. The fix: fade out, brief evening, fade in on
the next morning with the new tier already in place. One `AnimationPlayer`, one
`ColorRect`, a state change in between.

This is cheaper than any build animation and does more emotional work.

### 4. Add the handover

Capsule player, WASD, walk to the stall, press E. Three units of the resource leave
a counter, the fade plays, the stall is tier 1.

That is the entire game in miniature. Placeholder everything.

### 5. Stop

Do not add a second Kithrin, a house, or a gathering area in this milestone. The
second Kithrin is milestone 1, and it exists specifically to make scarcity real —
one stall with resources is a progress bar, two stalls competing for the same
resource is a choice.

---

## The tier ladder

Written in words before it's modelled. Each tier states what it lacks, what it
gains, and what that **unlocks in the world** — never a stat.

| Tier | Structure | Height | Unlocks |
|---|---|---|---|
| 0 | Crate and a tarp | ~1.3 m | Open midday only, closed in rain |
| 1 | Timber frame, roof, lantern | ~2.0 m | Open in rain; open into the evening |
| 2 | Proper shopfront, sign, flowerbox | ~2.6 m | Kithrin is present all day; new goods appear |

**The footprint is shared; the height is not.** All three tiers occupy the same
2 × 2 m plot on a 1 m grid, with the same anchor — that is what makes the swap read
as growth in place rather than a replacement. But they are deliberately different
heights, because against a 1.4 m Kithrin the ladder becomes something you can read
from across the square before a single detail resolves:

> Tier 0 you look **down** at. Tier 1 **meets your eye**. Tier 2 stands **over** you.

Signs and flowerboxes are what you notice once you've walked over. Silhouette is what
you notice from the other side of town, and it is doing most of the emotional work.

**Decided since this document was written:** the stall belongs to **Tilly**, a small
rounded fox-kin, and she trades in mushrooms. What comes back over the counter — and
what tier 2's "new goods appear" actually means — is still open.

---

## The one resource

One resource for this milestone. Scarcity cannot be tested with five.

Candidate: mushrooms (fits the world, cheap to model, reads at chibi scale).
Quantity to upgrade a tier: small enough that a single gathering trip could do it,
so the loop can be felt end to end in one session.

---

## Acceptance criteria

Milestone 0 is done when all of the following are true:

- [ ] Three stall tiers exist as Blender exports, sharing footprint and anchor
- [ ] Tiers can be swapped at runtime and the swap is driven by game state, not input
- [ ] The overnight fade transition plays between tiers
- [ ] A player capsule can walk up, press E, spend resources, and trigger the upgrade
- [ ] Jessop has looked at the upgrade several times and it still feels good

The last one is the real criterion. The others are just the machinery needed to
evaluate it.

---

## Known open questions

Not blocking milestone 0, but worth writing down so they don't get decided by
accident:

- Does the town max out, or does scarcity mean some Kithrin never reach tier 2?
  (Leaning toward scarcity — a town that always ends the same way ends the same for
  everyone.)
- Where do resources come from? Gathering areas exist in the concept but have no
  design yet.
- Is the player a Kithrin, or something else? The prose in this project's `ash-*`
  files is tone reference, not canon, but the robot-under-the-cloak idea lives there
  if it's wanted later.
- What does the player's own house do, if anything? It may not need to be a
  customization system at all if the *town* is the thing that changes.
