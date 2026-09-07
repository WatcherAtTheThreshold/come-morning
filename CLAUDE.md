# Come Morning — Claude Code guide

A cozy 3D town game in **Godot 4.7** (GDScript, Forward+, Jolt). Blender assets.
Working title.

**The core idea:** you trade gathered resources to the Kithrin (chibi animal-hybrid
townsfolk), and the town visibly upgrades in response. A stall goes from a crate and
a tarp to a real shopfront. The pitch is: *a place gets better because you kept
showing up.*

Resources are scarce on purpose. Feeding one Kithrin means another waits. The
finished town is a record of what the player cared about, so no two towns look alike.

The name is the loop: hand over goods, fade to evening, and come morning the stall
is different.

## Standing constraints

- **No combat.** Not softened combat, none. This is a deliberate move away from the
  action roguelike work in `threshold-deep`.
- **No procedural generation.** Hand-placed world. Small.
- **No crafting trees, no stats, no quest log, no dialogue tree.** If a system needs
  a schema, it's probably out of scope for now.
- **Upgrades unlock access, not numbers.** A roof means the stall is open in rain. A
  lantern means it's open in the evening. Never "+10% trade value."
- **The player never watches construction.** Hand over goods → fade to evening →
  next morning the stall is different. The Kithrin did it overnight.

## Working agreements

- Ask before adding a new system. Content creep is the main risk on this project,
  and it usually arrives disguised as a small convenience.
- Prefer data-driven `Resource` files (`KithrinData.gd`, `StallTier.gd`) over
  per-character scenes, so a new Kithrin is a data entry and not an architecture
  change. **This applies to the catalog only** — who a Kithrin is, what they trade,
  which meshes a tier uses. Behaviour stays in code. The moment a `StallTier`
  resource starts describing *when* a stall opens or *how* a handover resolves, the
  data has stopped being a roster and started being a badly-typed programming
  language.
- Placeholder art is fine everywhere except the thing currently being evaluated.
- Balance and feel values live as `const` at the top of the script that uses them,
  so playtest feedback is a one-number change.
- Typed GDScript. `:=` cannot infer from untyped sources — type loop variables
  explicitly (`for deg: float in angles`).
- Every colour comes from `Palette` (`scripts/palette.gd`). Never hardcode a colour
  anywhere else; the whole point is being able to re-grade in one file.
- Commit `.uid` and `.import` sidecars. Never commit `.godot/`.

## Current milestone

See `docs/design/milestone-0.md`. Nothing outside that document is in scope yet.
`docs/design/action-plan.md` is the ordered task list for it.

---

# Pipeline — inherited from `greenhorn`

Same Blender → glTF pipeline, shared palette atlas, modular kits on a fixed grid.
Everything below was paid for once already in that repo. Do not re-earn it.

## Naming assets

**A filename names the thing, never the version.** Git holds versions. A
`Tim2.blend` next to an archived `Tim.blend` is doing by hand what the repo does for
free, and it leaks: one shell version produced a bone called `shell2.socket`,
coupling a rig to a filename.

**Number the interchangeable, name the distinguished.** `crate1` and `barrel1` are
fine — they are slots, more are coming. Anything the player tells apart gets a real
name: Kithrin, stalls, trade goods.

**Pair by name, not by number.** A Kithrin's stall carries their name
(`tilly-stall-t0`, `tilly-stall-t1`, `tilly-stall-t2`). The roster in the Kithrin
resource is the actual pairing; matching numbers would be a second convention saying
the same thing, free to drift from the first.

Renaming in place is cheap — it does not touch a `.blend`'s relative texture paths.
*Moving* a file does, and breaks them silently.

## Scale

1 Blender unit = 1 metre = 1 Godot unit. Kithrin are chibi, so pick a canonical
height early and put it in this file. There are no pixels-per-metre in 3D geometry;
that idea only applies to texture density. Imported assets should be beveled (a small
Bevel modifier on everything) and, if textured, at roughly **32 texels per metre** to
match the `greenhorn` / `threshold-deep` family.

## Gotchas already paid for

### Blender to Godot

- **Godot deletes dots from animation names.** The glTF importer runs them through
  `validate_node_name()`, which strips characters illegal in node names.
  `hand.over` arrives as `handover`. It fails *selectively* — `idle` and `walk` are
  fine, so the rig looks healthy and only the dotted clips vanish.
- **An unapplied Object Mode scale on an armature shrinks everything socketed to
  it.** The character still looks right, because its meshes are children of that
  armature. A held prop is not. Cost most of a day: `Ctrl+A → All Transforms` on the
  armature *and* its meshes.
- **An unrecognised collision suffix fails completely silently.** `-con` instead of
  `-col` imports the mesh perfectly and gives you no collider, with nothing in the
  log. Only `-col`, `-convcol`, `-colonly` and `-convcolonly` are real.
- **`-convcol` fills in any hole.** A convex hull of a stall with an open front is a
  solid block. Anything you can walk into or see through wants `-col`.
- **A socket bone's parent decides what it follows; its position only decides where
  it sits.** Independent, so a correct position hides a wrong parent entirely until
  the rig animates. A prop that sits right in the rest pose and then drifts is a
  hierarchy bug, not a placement one.

### Controller

Only relevant once there is a player. `greenhorn`'s `player.gd` implements manual
step-up in `_try_step()` because Godot's `CharacterBody3D` will walk up a 45° ramp
and then refuse a 10 cm step. If this project ever gets a step, a kerb, or a stall
threshold, copy that function rather than rediscovering it.

### Physics layers

`Layers` (`scripts/layers.gd`) is a contract, not a convenience. Getting a mask wrong
fails quietly. Add it when there is something to collide with.
