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

## Art direction

Low-poly diorama. Chunky simplified forms, soft rounded silhouettes, generous bevels,
one flat colour per object. Think a hand-placed model village you could pick up — not
realism, not pastel, not painterly.

**Take the chunkiness, not the grade.** The low-poly-village reference this is drawn
from is brighter and more saturated than this game should be. Come Morning is
*earthy* — warm woods, worn canvas, muted greens. Borrow the simplicity of the forms
and the confidence of flat colour; leave the candy behind.

**Colour is the material.** Almost nothing here should be textured. A surface gets a
flat albedo from `Palette` and that is the whole look, which is what makes it
affordable for one person and what keeps the town re-gradable from a single file. If
something needs variation, reach for vertex colour before you reach for a UV map.

**Faces are geometry.** At 1.4 m and chibi proportions there are not enough texels in
a face to carry expression, and the Kithrin's face is the emotional payload of this
game — it is the thing you did all the gathering for. Build eyes, snout and markings
as geometry and flat colour, never as a texture map.

**Kithrin read as soft.** Continuous rounded forms, no plating, no visible joint gaps,
no hard mechanical seams. A grey clay render of a chibi character will always look a
bit robotic; that is the render, not the model — but the fix is in the *silhouette*,
so check it as a solid black shape before adding any detail. This matters here more
than on other projects: the world already contains robots, and a Kithrin that drifts
toward hard-surface stops being one of the townsfolk.

## Scale

1 Blender unit = 1 metre = 1 Godot unit. Real metres, always — the engine defaults,
Jolt's margins, gravity, and every constant inherited from `greenhorn` assume it.

**Chibi is a proportion, not a height.** A Kithrin is 3-4 heads tall with stubby
limbs. That is what makes them chibi. Their *height* is a separate decision, and it
is set close to human scale on purpose so that walk speeds, step heights, camera
arms, collision radii and borrowed props all behave without retuning.

| Thing | Size |
|---|---|
| Kithrin | **1.4 m** |
| Player | 1.4 m if a Kithrin, 1.7 m if not (undecided) |
| World grid | **1 m** |
| Stall footprint | **2 × 2 m**, identical across all three tiers |
| Stall counter | ~0.70 m — elbow height on a 1.4 m Kithrin, so she can lean on it |
| Doorway / passage clearance | 1.8 m |

Tier *heights* are deliberately not shared — see the ladder in
`docs/design/milestone-0.md`. The footprint is the reserved plot; the silhouette is
what grows.

There are no pixels-per-metre in 3D geometry; that idea only applies to texture
density. Imported assets should be beveled (a small Bevel modifier on everything).
The **32 texels per metre** convention from `greenhorn` / `threshold-deep` applies
only to anything that actually receives a texture, which here should be almost
nothing — see Art direction.

## Assets

**Working `.blend` files live outside the repo**, in `D:\Blender`. The repo holds
exported glTF and its `.import` sidecars only. `.blend` is binary — it does not diff
and does not merge, so every save-in-place would be a full copy in history.
`.gitignore` has a safety net for a stray save.

```
assets/
  kithrin/    tilly.gltf          one file per character
  stalls/     tilly-stall.gltf    ALL THREE TIERS in one file
  props/      mushroom.gltf       loose world objects
```

### A stall is one file, not a kit

Three tiers of one Kithrin's stall are **three objects inside a single `.blend`**,
exported as a single glTF. Not separate pieces assembled at runtime.

The reason is that a stall is not combinatorial. There are exactly three tiers, all
of them authored, and the game will never assemble an interesting stall you didn't
draw. Modular kits pay for themselves on *worlds* — walls, floors, terrain — where
the combinations outnumber the pieces. Here they'd buy nothing and cost an assembly
system, which is the kind of schema `Standing constraints` says to refuse.

One file also enforces what `milestone-0.md` needs: shared footprint, shared anchor.
Three files drift. And "model tier 2, then subtract" is duplicate-and-delete inside
one file — the workflow already wants this.

Objects named `tilly-stall-t0` / `-t1` / `-t2`, per the naming rule above. Anything
with an open front or a gap gets `-col`, never `-convcol`.

### Geometry versus node

Bake into the tier mesh anything the game never touches: roof, posts, counter, sign
board, flowerbox, awning. If it only needs to be *seen*, it is geometry.

Export as a named **empty** anything the game needs a position for. These are the
contract between the model and the code, and they exist so no GDScript file ever
hardcodes a `Vector3` offset that a re-model silently invalidates:

| Empty | What reads it |
|---|---|
| `Anchor` | tier swap origin — identical across t0/t1/t2 |
| `CounterPoint` | where handed-over goods land |
| `KithrinStand` | where Tilly stands and faces from |
| `LanternMount` | where the tier 1 `OmniLight3D` attaches |

The lantern is the clearest case: tier 1's unlock is *open into the evening*, so the
lantern is not decoration, it is a light the game turns on. Geometry in the mesh,
light on the mount.

### The cost you are signing up for

Bespoke stalls mean **three models per Kithrin**. Six Kithrin is eighteen stall
models, and that is the real production budget of this game — worth knowing now
rather than at Kithrin four.

Do not pre-solve it. Build Tilly's bespoke. The decision point is the *second*
Kithrin's stall: if the frame, roof and counter turn out to genuinely repeat, that is
when a shared structural kit with per-Kithrin dressing earns its keep. Not before.

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
