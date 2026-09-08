> **This is a parallel design, not this game's plan.**
>
> Filed 2026-09-08. `town-outline.md` describes a cozy *tableau-builder* — the
> player buys cards from stalls and places them into their own plot, where
> adjacency between them is explicitly "the whole game."
>
> Come Morning is the opposite proposition. Here the player's verb is **give**,
> and the standing constraint is that *the player never watches construction* —
> the Kithrin build, overnight, offscreen. There the player's verb is
> **arrange**. Fusing the two produces a game that is shy about both.
>
> It is kept because it is a real design and a genuine plan B: if milestone 0
> answers *no* — if watching a place improve isn't satisfying — this survives
> that failure, because its pleasure comes from arrangement rather than from
> watching. It may simply be the next game.
>
> **Three ideas were taken from it and belong to Come Morning now:** the day as
> the scarce resource, "nothing is strictly better" (which answers whether the
> town maxes out), and different Kithrin wanting different things.
>
> **Nothing else from this document is in scope.** Not the tableau, not the slot
> grid, not adjacency resolution, not `CardData`, not winter. If any of it starts
> arriving in Come Morning, that is drift, not a decision.

---

# Town — Production Outline

*Working title. A cozy tableau-builder in a Kithrin village. Godot + Blender.*

*Written 2026-09-08. Plan phase — nothing is built yet.*

---

## 0. What this is, in one line

You live in a small house at the edge of a village. You buy cards from the
stalls on the main street, and you **place** them into your plot, where they
become the thing on the card and start producing. The town is your tableau,
rendered in 3D.

Not a combat game. There is no fighting in it anywhere.

---

## 1. Where it comes from

This is not a new project from zero. It is the merge of two things that
already exist in this account, and reading both before starting is worth the
time.

**`shadows-of-the-deck`** — a finished JS deckbuilder. It already has the
market row, orb currency, purchase-to-discard, cost modifiers, a 28-card
market deck, and the Cruxflare pressure deck. Its README is a full systems
map. The card economy for this game is that economy with **one change**:

> Purchased cards are **placed and kept**, not discarded and cycled.

That single change turns a run-based deckbuilder into a village that grows.
Everything else in this document follows from it.

**`greenhorn`** — the Blender-to-Godot sandbox. `palette.gd`, `socket.gd`,
`anim_pick.gd`, `layers.gd`, and the drop-a-`.blend`-in-a-folder import mount.
The character pipeline this game needs is already built and documented there,
including the foliage-as-geometry decision and the MultiMesh scattering.
`docs/blender-checklist.md` still applies unchanged.

**Read `threshold-deep` as a warning, not a template.** 11,497 lines of
GDScript, `dungeon.gd` at 2,502 lines, six enemies at 478–939 lines each, and
exactly one `.tres` file in the whole project. Every piece of content there
cost a new script, so nothing compounded. Section 5 exists to prevent that
recurring.

---

## 2. The core loop

A day:

1. **Morning.** Placed cards produce automatically into storage. No clicking.
2. **Actions.** You have 3 actions. Spend them on any mix of:
   - gathering out in the wild (one resource type per trip)
   - visiting a stall (buy one card from its market row)
   - placing a card into your plot
   - a stall's own interaction (trade, a wager, a request)
3. **Evening.** The day ticks. Seasonal / pressure state advances.

The scarce resource is **the day**, not clicks. Gathering must compete with
shopping and placing, or it becomes an obligation rather than a choice.

---

## 3. The tableau

Four rules. All four are load-bearing; dropping any one collapses the game
into a shopping list.

**Space is finite.** The plot has ~12 slots, expandable to maybe 20 late. If
the player can eventually place everything, nothing is a choice.

**Cards modify each other, not just produce.** Adjacency is the whole game.
A bush next to the well yields more. A beehive produces nothing itself and
boosts everything flowering around it.

**Chains, not piles.** Raw resources hit a ceiling fast. Depth comes from
conversion — berries into dye, dye into cards the berry stall won't sell you.
Never from bigger numbers on the same resource.

**Nothing is strictly better.** A farm plot is not an upgraded berry bush. It
yields more, costs 2 slots, needs water adjacency, and produces nothing in
winter. The bush stays worth keeping because it is small and reliable. If
upgrades are strict, every mature town converges on the same arrangement and
they all look identical — which wastes the entire reason for modeling them.

### Starter set for the gate test

| Card | Slots | Effect |
|---|---|---|
| Berry Bush | 1 | +2 berries |
| Well | 1 | +1 water; adjacent producers +1 |
| Farm Plot | 2 | +5 grain, only if adjacent to water |
| Dye Vat | 1 | converts 3 berries → 1 dye |
| Beehive | 1 | adjacent producers +1; produces nothing |
| Drying Rack | 1 | stores 2 goods through winter |

**Cap adjacency at one condition per card** for the entire first slice.
"Bonus if adjacent to water" is charming. "Bonus if adjacent to two water and
not adjacent to smoke in the third season" is a debugging nightmare.

---

## 4. Pressure

`shadows-of-the-deck` got its tension from the Cruxflare deck — a countdown
that escalated and forced decisions. A cozy game needs the same *function* in
a gentler register.

First candidate: **winter**. A fixed number of days out, production stops for
most cards, and you either stored enough or you didn't. It's a deadline the
player can see coming and can get wrong, which is all a pressure system has
to do.

Deliberately unresolved until M4. Do not build it early.

---

## 5. Architecture

The rule that governs everything below: **content lives in `.tres` files, not
in scripts.** One scene per archetype, and every instance is data.

```
scenes/
  card_placeable.tscn    one scene, all placed cards
  stall.tscn             one scene, all stalls
  villager.tscn          one scene, all villagers
  plot.tscn              the slot grid
scripts/
  card_data.gd           Resource: the card schema
  stall_data.gd          Resource: merchant, stock, currency, palette
  villager_data.gd       Resource: name, meshes, palette, dialogue key
  plot.gd                slot grid, adjacency resolution, daily tick
  palette.gd             ported from greenhorn — every colour, one place
resources/
  cards/*.tres           berry_bush.tres, well.tres, ...
  stalls/*.tres
  villagers/*.tres
```

Rough schema:

```gdscript
class_name CardData extends Resource

@export var display_name: String
@export var mesh: PackedScene
@export var slots: int = 1
@export var cost: Dictionary          # {"berries": 3, "coin": 2}
@export var produces: Dictionary      # {"berries": 2}
@export var converts_from: Dictionary # {"berries": 3}
@export var converts_to: Dictionary   # {"dye": 1}
@export var adjacency_tag: String     # what this card counts as, e.g. "water"
@export var adjacency_needs: String   # what it wants nearby, "" for none
@export var adjacency_bonus: int
@export var winter_active: bool = true
```

Twelve cards for the code cost of one. Adding content is filling in a form in
the inspector, which is also what can be done on an evening with no appetite
for programming.

Same for stalls. A stall is a mesh, a stock list, a currency, a palette index
and a barker line. It is not a script.

### Art pipeline

Straight from `greenhorn`, unchanged:

- One chibi rig. Villager variety is head/ear swap + palette index.
- Cloaks and shawls are separate meshes on socket bones (`socket.gd`), never
  merged into the body.
- One texture atlas, one material for all props. Draw calls are the cost, not
  triangles.
- Scenery scattered as MultiMesh — one draw call per species.
- Placed cards are small props. Budget 100–400 tris each.

---

## 6. Milestone ladder

Each milestone exists to answer one question. If the gate answers no, stop
and fix the design rather than proceeding.

### M0 — Six cards on a table *(no Godot)*

Fork `shadows-of-the-deck` or write a throwaway HTML page. Six cards from the
table above, a 12-slot grid, a day counter, automatic production.

> **Gate: do six cards produce an argument?**

Play it twenty days. If there is a real decision about where the beehive goes
and whether the second bush is worth the slot, the design works. If placement
feels obvious every time, adjacency isn't doing enough and no amount of 3D
will rescue it. This is a weekend, not a month, and it protects everything
after it.

### M1 — The plot in Godot

Slot grid, place from an inventory, adjacency resolution, daily tick. Grey
boxes for meshes. No stalls, no villagers, no art.

> **Gate: does placement read spatially?** Can you look at the plot and see
> why the corner bush is underperforming, without opening a menu?

### M2 — One stall

One `stall.tscn` driven by one `.tres`. Market row of four, buy with
resources, restock. Walk up, interact, leave.

> **Gate: is buying a decision?** Two cards you want and money for one is the
> minimum viable version of that.

### M3 — The day

Three actions, a gathering trip out of town, evening tick. The street gets a
second and third stall — both from `.tres`, no new code. If M3 requires new
code per stall, section 5 has already failed.

> **Gate: does the morning cost something?** Choosing to gather has to mean
> not visiting the dye seller.

### M4 — Winter

The pressure system. A visible deadline, a stored-goods check, consequences.

> **Gate: can the player get it wrong?**

---

## 7. Out of scope

Explicitly not in the first slice, regardless of how cheap they look:

- Combat of any kind
- Villager daily schedules, day/night cycle
- Crafting trees separate from the card system
- More than one town
- Procedural anything
- Dialogue beyond one line per stall
- Multi-condition adjacency
- The card duel / gambling minigame *(a stall that sells face-down cards
  cheap is the 90% version and costs nothing)*
- Robot and future-tech elements as **systems**. One robot merchant on the
  street is texture, costs one model, and buys the whole tonal question of
  what this world is. That is the correct amount for now.

---

## 8. Open questions

- **Name.** "Town" is a placeholder.
- **Does the house matter separately from the town?** Current thinking: the
  house *is* the starting tableau and the street is the expansion, so they're
  one progression rather than two.
- **How does the town street grow?** Do stalls unlock by reputation, by
  supplying them, or by story? Not needed before M3.
- **Do villagers want things?** A request system is the obvious source of
  goals but it's also a whole content pipeline. Defer past M4.
- **Relationship to the Ash stories / shared world.** `greenhorn/docs/shared-world.md`
  covers the same world. Worth deciding whether this is in it or beside it,
  but not before M2.
- **Kithrin, or something else?** Plan phase. The chibi animal-hybrid look in
  reference is the anchor, not the name.

---

## 9. Notes for whoever picks this up

The failure mode for this project is not ambition. It is content living in
code. Every time something feels like it needs a new script, check whether it
could be a `.tres` on an existing scene instead. The answer is usually yes,
and the sixth stall should cost nothing.

The second failure mode is drifting back toward action. It has happened three
times in this account. If a milestone starts to be about hit detection,
something has gone wrong upstream.
