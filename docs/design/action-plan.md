# Action plan — Milestone 0

The ordered task list for `milestone-0.md`. That document says *what* and *why*;
this one says *next*. Nothing here adds scope — where it differs from
`milestone-0.md`, the difference is called out and marked as a proposal.

---

## Step 0 — Decide who the stall belongs to

`milestone-0.md` lists this as "TBD before modelling", but step 1 is *model tier 2
in Blender* and a silhouette can't be modelled without knowing whose stall it is.
This is the first task, not a footnote.

**Candidate: Tilly.** She already exists in `docs/reference/ash-2-*` and
`ash-3-*` — explicitly Kithren, and introduced foraging a stand of mushrooms for
the evening meal. Taking her makes the milestone's mushroom resource
self-justifying, hands you the props for free (baskets, drying racks, a cloth
sack), and gives the milestone a character with a written voice instead of a
placeholder.

It also quietly answers one of the open questions by demonstration: a Kithrin who
is plainly not the player.

**Decide and write down:**

- [x] **Which Kithrin — Tilly.** Small rounded fox-kin. Soft continuous forms, no
      plating and no visible joints; big head, short stubby limbs, tail. The fur
      reads through *silhouette*, never through texture.
- [x] **What they trade in — mushrooms in, nothing back.** Settled 2026-09-08:
      milestone 0 has no currency, no tickets and no return good, because any
      layer between the gift and the change contaminates what this milestone
      measures. The likely long-term answer — the Kithrin themselves are the
      conversion layer — is written up under "What comes back over the counter"
      in `milestone-0.md`, for milestone 2 or later.
- [x] **Kithrin height — 1.4 m.** Recorded in `CLAUDE.md` under Scale.
- [x] **Stall footprint — 2 × 2 m** on a 1 m grid, shared by all three tiers.
      Heights are *not* shared; see the tier ladder in `milestone-0.md`.

---

## Step 1 — Grey-box the whole loop in Godot, before Blender

*Proposal — this is an addition to `milestone-0.md`, made on its own logic.*

Milestone 0 exists to answer one question cheaply, and each step is meant to be a
checkpoint that can kill the idea. As written, the most expensive step (three
Blender models) comes before any feedback at all.

So: build the tier ladder out of CSG boxes first. A box. A box with a roof. A box
with a roof and a sign board. Then do the fade transition on *those*.

If an overnight change doesn't read as growth in boxes, it will not read as growth
in good models either — and you'd know in an evening rather than after a day of
modelling. If it does read, you go to Blender already knowing the footprint, the
camera distance, and the transition timing.

- [x] `scenes/stall_test.tscn` — ground plane, one directional light, three CSG
      tier variants, nothing else
- [x] `scripts/stall.gd` — holds a `tier: int`, shows one variant
- [x] Debug keys 1/2/3 to swap tier, handled in `_unhandled_input` inside a
      script that gets deleted, **not** added to the input map in `project.godot`.
      They must not outlive the milestone.

**Checkpoint: look at it. — PASSED 2026-09-08.** The three silhouettes differ in
kind and not merely in size, and the ladder reads against a 1.4 m capsule: head
above the tarp, well under the tier 1 roof, dwarfed by tier 2. Heights unchanged.

Giving each tier its defining feature rather than three plain boxes is what made
the checkpoint answerable — Jessop's read was that the dressing is what let the
progression register.

---

## Step 2 — Solve the transition

An instant mesh swap reads as a bug. Fade out, brief evening, fade in on the next
morning with the new tier already in place.

- [x] One `ColorRect` over the viewport — **driven by a `Tween`, not an
      `AnimationPlayer`.** Deviation from `milestone-0.md`, made because the
      lighting has to be interpolated *between Palette constants*, and an
      `AnimationPlayer` would bake those colours into the `.tscn` as keyframes.
      That breaks the rule that the world re-grades from one file, and it splits
      the sequence across two places. One `Tween` in `overnight.gd` keeps every
      colour in `Palette` and every timing as a `const`.
- [x] Tier changes at the darkest point, never on screen
- [x] The evening beat is lit differently, not just darker — the sun warms,
      drops toward the horizon and swings west while the overlay closes, so it
      reads as a sunset rather than a fade-out
- [x] Timing values as `const` at the top of the script so the pacing is a
      one-number change — `DUSK_TIME`, `NIGHT_TIME`, `DAWN_TIME`

Dawn is deliberately slower than dusk. The morning is the payoff and is allowed
to linger; the evening only has to get out of the way.

The overlay fades through `Palette.NIGHT`, a deep indigo, rather than black.
Black is an interruption; a night sky is a pause.

**Verified headless 2026-09-08:** overlay reaches alpha 1.0, sun energy drops
1.15 → 0.55, the tier swaps while dark with only the new tier visible, and both
alpha and sun energy return to morning values. What that does *not* tell anyone
is whether it feels good — that is the checkpoint below.

**Checkpoint: does the fade do the emotional work the doc claims it does?** This
is the cheapest possible version of the game's signature moment. If it lands with
boxes, the idea is real.

### PASSED 2026-09-08

Jessop: *"far better than the switch alone. It looks good and it feels right...
you never feel like you are waiting."*

Two findings worth keeping:

**The travelling shadow is doing the work, not the fade alone.** He deliberately
tried to look away during the transition and still registered it — a shadow
sweeping across the ground reads peripherally in a way a screen dimming does not.
This makes the sun *rotation* between `SUN_ANGLE_MORNING` and `SUN_ANGLE_EVENING`
load-bearing rather than decorative. A future simplification to "just fade the
colour" would look nearly identical in a screenshot and lose most of the effect
in motion. Noted in `overnight.gd` where the temptation would arise.

**The pacing is right on the first guess.** `DUSK_TIME 1.6 / NIGHT_TIME 0.9 /
DAWN_TIME 2.0` produced no sense of waiting. Treat these as confirmed rather than
provisional; change them only for a reason, not to fiddle.

The idea is real. Step 3's Blender day is now worth spending.

---

## Step 3 — Model the real tiers in Blender

### Carried over from the grey-box checkpoint

Observed 2026-09-08 looking at the CSG version. None of these were fixed in CSG,
because the boxes get deleted here.

**The counter must not recede as the stall improves.** In the grey box the
handover surface is fully exposed at tier 0 and ends up recessed inside a dark
enclosure behind a large sign at tier 2. That runs directly against what tier 2
means — *the Kithrin is present all day*. The upgrade must never hide the person
the player did all the gathering for. Fix with a wider or taller front opening, a
lighter interior, or a counter that sits proud of the facade. This is a design
constraint on the model, not a preference.

- [x] Tarp reads as a tabletop — it needs to sag and lean, sit narrower than the
      crate span, and pull forward to actually shelter the counter
- [x] Lantern floats. It needs a bracket to the post or the roof
- [x] Tier 2 sign is a billboard across the frontage. Hang it above the opening,
      smaller, rather than bolting it across
- [x] Pull the grade back toward earthy — tier 1's thatch is the most saturated
      thing on screen, and tier 2's walls go cold against the terracotta roof

Only now. Build **tier 2 first** — the finished stall with the sign, the
flowerbox, the good roof — then subtract to get tier 1, then tier 0.

Building forward from a crate produces three objects that don't share a
silhouette, and the upgrade reads as a replacement rather than growth.

- [ ] Shared footprint and anchor point across all three
- [x] `-col` on anything with a gap or an open front, never `-convcol`
      (see `CLAUDE.md` gotchas)
- [x] Small Bevel modifier on everything
- [x] `Ctrl+A → All Transforms` before export
- [x] Named `<kithrin>-stall-t0/t1/t2`, never numbered by version
- [x] Swap the CSG variants for the imports; the tier ladder code does not change

---

## Step 4 — The handover

- [ ] Capsule player, WASD, no jump, no combat
- [ ] Walk to the stall, press E
- [ ] Three units of the resource leave a counter
- [ ] The fade plays; the stall is tier 1
- [ ] **Delete the debug tier keys.** Tier is now driven by game state only.

That is the entire game in miniature. Placeholder everything.

---

## Step 5 — Stop

No second Kithrin. No house. No gathering area. No save. No UI beyond the counter.

The second Kithrin is milestone 1 and it exists specifically to make scarcity
real — one stall with resources is a progress bar; two stalls competing for the
same resource is a choice.

---

## The real acceptance criterion

> Jessop has looked at the upgrade several times and it still feels good.

Everything else in `milestone-0.md`'s checklist is just the machinery needed to
evaluate that. One suggestion for making it a fair test: look at it again the
next morning, in a session that isn't the one where you built it. The version of
you that just got the fade working is not a neutral judge of the fade.

If the answer is no, the correct outcome of milestone 0 is that this repo stops.
That is what it's for.
