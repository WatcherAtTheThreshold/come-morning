# Expedition outline — the town, the woods, the deep

> **This is a direction, not scope.** Filed 2026-09-11.
>
> Nothing in this document is in scope until the milestone that names it.
> The current milestone is still milestone 1 in `milestone-0.md`'s ladder:
> a second Kithrin, to make scarcity real. That question has to be answered
> first, because this document depends on the answer.
>
> Come Morning's standing constraints in `CLAUDE.md` — **no combat, no
> procedural generation** — hold, unchanged, through milestone 3 below. They are
> only reopened at milestone 4, deliberately, in writing. If combat or a
> generator arrives before that, it is drift, not a decision.

**The pitch:** a small town at the edge of a wood. Everything you bring back
changes where you can go next.

**The question this whole direction exists to answer:** *does going out make
coming home better?* If it does, Come Morning grows outward. If it does not,
Come Morning is finished as the town game it already is, and that is a good
outcome.

---

## Where it comes from

Three repos, one engine version, one pipeline.

| Repo | What it brings | Becomes |
|---|---|---|
| `come-morning` | Tier ladder, overnight fade, `Palette`, the constraints | The town, nearly as-is |
| `greenhorn` | Third-person controller with `_try_step()`, camera arm, `socket.gd`, MultiMesh scenery, bug AI, hit feedback | The player and the woods |
| `threshold-deep` | `dungeon_generator.gd`, mist-door grammar, creature afterlives, the dry/damp/deep tile swap | The deep — as a generator and as design knowledge, more than as code |

**What does not transfer:** Threshold Deep's first-person, billboard-sprite world.
This game has one camera and one art language — third person, low-poly diorama.
Threshold Deep's creatures and most of `dungeon.gd` stay where they are.

The generator survives because it produces 2D grid data *before* anything
touches a GridMap. That makes it camera-agnostic. It is the one large piece of
Threshold Deep that crosses over intact.

**Parked, with reasoning:** third person above ground, first person below —
stepping over the threshold changes how you see. It is evocative. It also costs
two controllers, two art pipelines, and two sets of feel constants. Not unless
the rest of the game is finished and it is the last good idea left.

### The reference shape

This is a known genre, which is good news. Moonlighter (shop by day, dungeon by
night), Stardew's mines, Darkest Dungeon's hamlet upgraded with heirlooms from
below. What this game adds is the middle register — the woods — and a town you
walk around in rather than a set of menus.

The genre fails in one of two ways, and both are worth naming now:

- **The town becomes a menu between runs.** A shop screen with nice art.
- **The expedition becomes a chore** you do to earn the cozy part.

Everything below is designed so that each half needs the other.

---

## No storyline

**Decided 2026-09-11.** Nothing is told. No dialogue, no quest log, no named
protagonist, no lore dumps.

Story in earlier projects has often arrived as a search for mechanics. Here the
mechanics are chosen first and the story is whatever they leave behind.
Threshold Deep is the model: its story unfolds and is never explained, only
played.

> **The story is the town.**

Which stalls grew. Which paths opened. Which Kithrin waited. What was at the
bottom. A finished town is a record of a playthrough, and two records should
never match.

The `ash-*` files remain tone reference. The world can leak through — a robot
standing in a field, a sub-station with levels nobody has explored — but only as
things that are *there*, never as things anyone explains.

---

## The day

The day is the loop, and it is the scarce resource.

1. **Morning.** Wake in town. The stalls show what last night changed.
2. **One trip.** Out into the woods, or down into the deep.
3. **Dusk.** Come home carrying what you found.
4. **The gift.** Hand it to one Kithrin.
5. **The overnight fade.** Come morning, the stall is different.

One trip, one gift, one Kithrin helped per night. Scarcity comes from the day,
not from a number on a counter.

### The day cannot be the only scarce thing

*Added 2026-09-11, and it needs settling before milestone 1 is judged.*

`milestone-0.md` decided that **the town must not max out** — if every stall can
reach tier 2, every mature town converges and modelling three tiers per Kithrin
buys nothing.

Day-scarcity alone does not deliver that. If the only limit is one gift per night,
every Kithrin eventually gets everything and the player is choosing *turn order*.
That is exactly the degraded choice `milestone-0.md` rejects currency for: *"the
choice degrades from who do I care about into who goes first."*

Three ways out. Pick one deliberately rather than discovering which one happened:

1. **The game ends** — reaching the bottom stops it before everyone is maxed. This
   promotes *does the game end?* from an open question to a load-bearing one.
2. **Resources stay genuinely scarce**, so the day is not the only limit.
3. **Different Kithrin want different things**, so the route you took decides who
   you *can* help rather than who you help first.

Leaning toward 3, because one trip per day already means you come home with
whatever that place had — the mechanism exists for free. `milestone-0.md` proposes
the same thing under *what comes back over the counter*.

**The overnight fade becomes the heartbeat of the whole game.** It is no longer
a transition between tiers; it is the end of every expedition. Everything
`action-plan.md` learned about it carries over unchanged — including that the
*travelling shadow* is doing the work, not the fade alone. `DUSK_TIME`,
`NIGHT_TIME` and `DAWN_TIME` are confirmed values. Do not fiddle with them
because the context changed.

---

## Three registers

The further from town, the more it becomes Threshold Deep.

| | Town | Woods | Deep |
|---|---|---|---|
| **Verb** | Give | Gather | Fight |
| **Combat** | None, ever | Hazards to route around; creatures are obstacles, not loot | Yes |
| **World** | Hand-placed | Hand-placed | Generated from an authored room kit |
| **Death** | — | Lose the day's haul, wake in town | Lose the day's haul, wake in town |
| **Source repo** | `come-morning` | `greenhorn` | `threshold-deep` |

This is where "hit things with a stick" lives: in the one place designed for it.
The woods can be tense without being a combat zone.

**The woods reward understanding, not killing.** Creatures in the woods do not
drop resources. If they did, the woods would teach the player to farm them, and
the middle register would collapse into a second, worse dungeon. This follows
the shape every one of the `ash-*` stories already has: the threat is misread,
and the cause is usually a machine.

**The deep has one resource that exists nowhere else.** Tier 2 upgrades need it.
That is what ties the deep back to the town — without it, the deep is optional
and the town never asks you to go down.

---

## Upgrades are keys

The rule from `CLAUDE.md` — *upgrades unlock access, not numbers* — pointed
outward.

In the town alone, tier 1's lantern means the stall is open into the evening.
Out past the gate, a Kithrin's upgrade opens a *place*. This is Zelda's actual
structure — the hookshot opens the ledge — except the keys come from the
Kithrin, not from chests.

`milestone-0.md` already says the town becomes *"a dependency graph expressed
entirely through who you chose to help."* This extends the graph past the edge
of town. **The world you can reach is a record of who you helped.**

### More than one door

Scarcity means the player cannot upgrade everyone. So:

> **No single Kithrin is ever required.** Every gate has at least two keys, held
> by different Kithrin.

This does three jobs at once:

- **No soft-locks.** A player who chose differently is never stuck.
- **Nothing is strictly better** — the rule borrowed from `town-outline.md` —
  survives contact with progression.
- **Two playthroughs reach the bottom by different paths** and end with
  different towns, which is the whole pitch.

### Illustrative graph

*Placeholders except where marked. This table exists to show the shape, not to
decide the Kithrin.*

| Kithrin | Tier 1 opens | Tier 2 opens |
|---|---|---|
| **Tilly** (decided) — mushrooms | Lantern: stay out past dusk | Dried bundles that keep: reach the far side of the woods |
| Rope-maker | Rope: the ravine | Deep floor 2, by the shaft |
| Weaver | Cloak: the damp caves | Deep floor 2, by the caves |
| Lamp-maker | The lit path into deep floor 1 | Deep floor 3 |

Note that deep floor 2 has two doors, from two different Kithrin. Every depth
should be reachable by at least two routes; draw the real graph on paper before
modelling a single stall.

---

## The deep

One dungeon. Three floors. A bottom.

- **Layout from the generator,** rooms from an authored kit. The generator is
  proven not to trap the player; keep that guarantee.
- **Two or three creature families,** each cheaper to build than the last.
- **A hand-built final room.**
- **At the bottom, something found and acted on — never explained.** Given the
  world's instincts, probably a machine rather than a monster.

### What is at the bottom, probably

Left open on purpose, and it should come out of building the deep. But it may
already be written. `alternates/wider-world-game.md` records the Smallish Realms
ending: Magdaline falls into a cave, finds glowing crystals and ancient machinery,
ventures further, and finds **the Cave Titan** — a giant robot lying dormant, who
stirs as she approaches and seems to have been expecting her.

That is this beat, designed once already, as the climax of a whole game. It does
not have to be reused. It does mean the shape is known.

### The one idea that would tie the registers together

*Offered, not urged. Do not build toward it early — just do not foreclose it.*

`greenhorn/docs/shared-world.md` identifies the recurring shape across every story
in this world: **a threat is misread, and the cause is usually a machine, and
usually nobody's fault.** It says plainly that *"this shape is what the work is
about."*

If the thing at the bottom is *causing* what is wrong in the woods, then the three
registers stop being three places and become one idea. The woods are no longer a
corridor between town and dungeon; they are the evidence. The deep stops being
justified by a resource and starts being justified by a question.

This needs no dialogue and no lore, so *No storyline* survives intact. It is
Ash 2's structure — a failing sensor makes the peccaries seem malicious — told at
the scale of a game rather than a short story.

### Content has to compound

Threshold Deep is the warning here. Its *tiles* compounded — the dry/damp/deep
swap made each floor cheaper than the one before. Its *creatures* did not: six
enemies at 478–939 lines each, and one `.tres` file in the whole project.

This game has three kinds of content, and all three must compound:

- **Kithrin** — data resources (`KithrinData`, `StallTier`), per the existing
  working agreement. A new Kithrin is a data entry.
- **Rooms** — a kit, not bespoke scenes.
- **Creatures** — shared behaviour in code, per-creature differences in data.
  The second creature family is the test. If it costs as much as the first, stop
  and fix the architecture before building a third.

### Procedural, and why

The deep is generated because it is **revisited**: its resource is needed for
every tier 2 upgrade, so the player goes down more than once. If playtesting
shows the deep is visited once per playthrough, reopen this — a single visit
wants a designed dungeon, not a generator.

---

## The size

| Thing | Count | Cost |
|---|---|---|
| Kithrin | 4 | One character model each |
| Stall models | **12** | Three tiers each — **this is the real art budget** |
| Woods | 1 area | Hand-placed, Greenhorn's MultiMesh scenery |
| Deep | 3 floors | One room kit, one tile set per floor |
| Creature families | 2–3 | See *Content has to compound* |
| Resources | 3–4 | 2–3 from the woods, 1 from the deep |
| Unlocks | 8 | Two per Kithrin |

Roughly the size of Threshold Deep's demo, which has already been shipped once.

**That comparison flatters, and the difference is the whole risk.** Threshold
Deep's creatures were billboarded sprites and its levels were GridMap tiles. This
is full 3D modelling, in a pipeline started in mid-2026, where one Kithrin's three
tiers took several sessions. Twelve stalls at that rate is the thing most likely to
stall this project — not the code, not the design.

The lever already exists in `CLAUDE.md`: *"the decision point is the second
Kithrin's stall — if the frame, roof and counter genuinely repeat, that is when a
shared structural kit with per-Kithrin dressing earns its keep."* One kit plus
twelve dressings against twelve bespoke stalls is the largest cost difference
available anywhere in this document, and milestone 1 is when it becomes answerable.

---

## The milestone ladder

Each milestone answers one question and can kill the direction cheaply.

| # | Milestone | The question | Fits current constraints? |
|---|---|---|---|
| 0 | One stall, three tiers | Does the upgrade feel good? | **Passed** |
| 1 | Second Kithrin, first characters | Does choosing who to help feel like a real choice? | Yes |
| 2 | Out the gate | Does carrying goods home make the fade hit harder? | Yes |
| 3 | The first key | Does a Kithrin's upgrade feel like a key? | Yes |
| 4 | One floor down | Does the deep feel like a different register, not harder woods? | **No — the fork** |
| 5 | Full width | Four Kithrin, the woods, three floors, a bottom | No |

### Milestone 1 — the second Kithrin, and the first characters

The milestone's question is unchanged: **does choosing who to help feel like a real
choice?** A capsule answers that question perfectly well, which is the important
thing to hold onto — the character work below runs *alongside* the milestone and
must never become its critical path. If the models slip, milestone 1 still lands.

Two additional questions get answered by building it, and both are cheap to notice
and expensive to discover late:

- **Does the stall structure repeat?** See *The size*. Model Tilly's neighbour and
  look at whether frame, roof and counter are doing the same job. If they are, the
  remaining ten stalls are dressings on a kit.
- **Does the scarcity bite?** See *The day cannot be the only scarce thing*. Which
  of the three resolutions is actually in play needs to be true during this
  milestone, or the answer to the milestone's own question is not trustworthy.

#### The player gets a body

A **cloaked figure**, species deliberately undecided. Kithrin, robot, human or
other all stay on the table, and the cloak is the device that keeps them there.

The cloak defers identity. It does not defer everything, and it is worth being
clear about what building this commits to:

- **Height and proportion are the real commitment.** A cloak hides a torso; it does
  not hide that something is 1.4 m and three-and-a-half heads tall. Build at
  **1.4 m chibi** and the player reads as small folk whatever is underneath — which
  keeps Kithrin, small robot and other open, and closes "human adult". That is a
  fine trade and it should be made knowingly. Every constant already in the project
  assumes it: walk speed 2.4 m/s, camera pivot at 1.2 m, a counter at 0.70 m that a
  1.7 m player would loom over.
- **Hands are the second tell, after the head.** Timothy's turnaround has visible
  robot hands; Magdaline's are human. If the player's hands show, the species is
  decided by accident. Gloves, wraps, or sleeves past the wrist.
- **The hood has to be deep enough to hold no face.** A shallow hood with a visible
  jaw has already answered the question.

#### One base mesh, not several

Build **one** and let variety come from head, ears and palette. This is
`greenhorn`'s documented approach — *one chibi rig; villager variety is head/ear
swap plus palette index* — and it is what makes a fourth Kithrin affordable. A
second base mesh doubles rigging, animation and socket work and buys nothing at
this scale.

The player and the Kithrin are the same base mesh. The player wears a cloak and a
deep hood; Tilly wears fox ears and a tail.

#### What the base mesh needs

- A-pose or T-pose, symmetrical, mirrored and then applied
- Origin at the feet, centred on X and Y
- `Ctrl+A → All Transforms` before it goes anywhere near Godot
- Low poly to match the stalls — a few hundred to a couple of thousand triangles
- UV'd to the 64 × 64 `Palette.png`, which already has room left for eyes
- **Faces as geometry**, per `CLAUDE.md` — eyes, snout and markings modelled and
  flat-coloured, never painted into a texture at this scale
- **The cloak is a separate mesh on a socket, never merged into the body.** This is
  a rule `greenhorn` already paid for. Merging it means every future cloak, shawl
  or apron is a new character rather than a new prop
- No `.001` suffixes; object names become Godot node names

Rigging and animation are **not** milestone 1. A T-posed figure sliding to the
counter answers the milestone's question exactly as well as a walk cycle does, and
the walk cycle is a day that does not have to be spent yet.

### Milestone 2 — out the gate

One clearing past the edge of town. Mushrooms, and one hazard. Tilly's stall.

The test is a comparison: pick the mushrooms up beside the stall, then pick them
up in the clearing and carry them home. If the second version does not make the
fade land harder, going out adds nothing — **and the correct outcome is that
this document is filed as an alternate**, the way `town-outline.md` was.

**The comparison is confounded the first time and has to be run cold.** The
clearing trip is not only *carrying* — it is also a new place, and novelty pays
once regardless of whether the design works. Milestone 0 already taught this: its
real acceptance criterion is *"looked at it several times and it still feels
good"*, and the verdict was deliberately held for a session that had not built the
thing. Same clause here, or the answer is yes whether or not it is true.

### Milestone 3 — the first key

One upgrade opens one new place. The tier 1 lantern lets you stay out past dusk
and reach something you could see but not get to.

The test: does handing over the mushrooms now feel like buying access, or like
feeding a progress bar? If it is a progress bar, the key idea is wrong, and the
graph above is wrong with it.

### Milestone 4 — the fork

This is where combat and the generator arrive, so it is where they are decided,
not before. Before any code:

- [ ] Amend `CLAUDE.md`'s standing constraints in writing — which rule changes,
      and why. Constraints are never silently outgrown.
- [ ] Decide whether this is still `come-morning` or a new repo.
- [ ] Draw the full key graph on paper, with two doors to every depth.

Then: the generator, one room kit, one creature family, one floor.

---

## Integrations considered

*Reviewed 2026-09-11 against `threshold-deep/docs/roadmap.md` (post-demo and
parking lot) and this folder's `alternates/`. Recorded so that the ones taken have
a reason and the ones refused do not come back around.*

### Taken

**Noise as a route decision** — from Threshold Deep's parking lot, where it was
parked *reluctantly*. Its blocking problem there was stated precisely: all four
versions make the game louder and harder, and the player has **no quiet option**,
so *"this is just everything is worse now."* The lever it wanted was
stone-quiet/wood-loud, turning noise into a route choice rather than a difficulty
tax.

The woods supply that quiet option by design. They are already *hazards to route
around*, with creatures as obstacles rather than loot, rewarding understanding
rather than killing. Noise fits the middle register better than it ever fit a
dungeon, and it gives the woods a verb that is not combat. Milestone 2 or later;
noted here so it is not reinvented.

**The town is the meta-progression.** Threshold Deep's post-demo list calls
MetaState *"still the highest-leverage missing system"* — Isaac-style unlocks
banked across runs. This design already has it, and has it diegetically: you lose
the day's haul and wake in town, but the town keeps what you gave it. An unlock
screen you walk around in. Nothing to build; something to recognise, because it
means the deep does not need a separate progression system bolted on.

**Free items add power, not decisions.** The Isaac lesson from Threshold Deep's
secret-rooms entry — nearly every source in that game carries a cost or a
condition. Applies directly to the deep's exclusive resource: if it is simply lying
there to be collected, the deep becomes a farm and the third register collapses the
way the woods would if creatures dropped loot.

**Cold judgement on feel questions**, from milestone 0. Already folded into
milestone 2 above.

### Refused

**Adjacency and the tableau**, from `alternates/town-outline.md`. Placing stalls so
they modify each other would make the town an optimisation problem, and this
document's best claim is that *the story is the town*. A town you solve is not a
town that remembers you.

### Warning — an instinct that transfers wrong

Threshold Deep never scores time **on purpose**, so lingering pays and secrets
reward it. This game makes the day the scarce resource, so lingering *costs*. Those
are opposite, and the habit will transfer without being noticed — most dangerously
around discovery, which Threshold Deep rewards by exploration and this game charges
for by the hour. Anything imported from that parking lot needs checking against
which of the two economies it assumes.

## Out of scope

For the whole of this direction, not just the next milestone:

- A second village
- A second dungeon
- Currency — see `milestone-0.md`, *No currency, ever*; the reasoning applies
  here unchanged
- Crafting trees
- Dialogue
- A named protagonist
- A player house, unless a milestone gives it a job

---

## Known open questions

Not blocking anything yet, but worth writing down so they don't get decided by
accident:

- **Who is the player?** Default: a cloaked figure, nothing said. See *The player
  gets a body* under milestone 1 for what the cloak defers and what it quietly
  does not. The silhouette leaves room for a robot under the cloak if the world
  wants one later, and it never has to be revealed.
- **How long is a trip in real minutes?** The day is the scarce resource, so this
  sets the pace of the whole game. First guess: short enough that one session
  holds several days.
- **Does the game end?** Reaching the bottom is a natural ending. Whether the
  town keeps going after it is open.
- **What happens at the bottom?** Undecided on purpose. It should come out of
  building the deep, not be written ahead of it.
- **Do the woods change over time?** A town that grows next to woods that never
  change may feel lopsided.
- **Saving.** Needed by milestone 5. Not before.
- **Do Kithrin ever leave the town?** Tempting. Almost certainly a new system.
  Ask first.
