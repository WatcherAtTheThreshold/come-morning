# Come Morning

*Working title. A cozy 3D town game. Godot 4.7 + Blender.*

You gather resources and trade them to the Kithrin — chibi animal-hybrid townsfolk —
and the town visibly upgrades in response. A stall goes from a crate and a tarp to a
timber frame with a lantern to a proper shopfront with a sign and a flowerbox.

You never watch the building happen. You hand over goods, the day fades, and come
morning the stall is different. The Kithrin did it overnight.

Resources are scarce on purpose. Feeding one Kithrin means another waits, so the
finished town is a record of what the player cared about. No two towns look alike.

**No combat. No procedural generation. No stats.** Upgrades unlock access to the
world — open in the rain, open in the evening — never a number.

Set in the same world as the `ash-*` prose in `docs/reference/`, which is tone
reference rather than canon.

## State

**Milestone 0 is built and playable.** Walk up to Tilly's stall, press E three
times to put mushrooms on her counter, and the day closes — come morning the stall
is better. Three modelled tiers, an overnight transition, and the whole loop end to
end.

Its one remaining acceptance criterion is a judgement call that has to be made
cold, away from the session that built it: *does the upgrade still feel good on the
fifth viewing?* Until that is answered, nothing beyond milestone 0 is in scope.

## Running it

Open the project folder in Godot 4.7 and press play. No build step, no
dependencies. `E` gives a mushroom, `WASD` walks, `R` resets the run. `1`/`2`/`3`
jump between tiers — a debug convenience that gets deleted when the milestone
closes.

## The documents

Read in this order:

- `CLAUDE.md` — constraints, working agreements, and the Blender pipeline inherited
  from `greenhorn`. The standing constraints are load-bearing, not preferences
- `docs/design/milestone-0.md` — the one question this milestone exists to answer,
  and what the tier ladder means
- `docs/design/action-plan.md` — the ordered task list, with each checkpoint's
  result recorded as it was reached
- `docs/design/alternates/` — designs deliberately **not** being built. Parked
  because they are good, not because they are bad
- `docs/reference/` — the `ash-*` prose. Tone reference, not canon

## What comes next

Milestone 1 is the **second Kithrin**, and it exists for one reason: one stall with
resources is a progress bar, two stalls competing for the same mushrooms is a
choice. Scarcity is not real until something has to wait.

Everything else — gathering, the day as a budget, what comes back over the counter
— is written up as open questions in `milestone-0.md` and stays there until that
question is answered.
