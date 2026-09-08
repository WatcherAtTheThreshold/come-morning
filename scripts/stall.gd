extends Node3D
class_name Stall

## Grey-box stall for milestone 0. All three tiers are built from CSG at runtime
## rather than authored in the .tscn, so tuning the ladder is editing a number in
## this file — no node-dragging, nothing to merge-conflict.
##
## At action-plan step 3 the CSG is replaced by an imported glTF. The tier state
## and the `tier` property below do not change when that happens; only _build_*
## goes away. Nothing outside this file should know the stall is made of boxes.

# --- The tier ladder ------------------------------------------------------
# These are first guesses from docs/design/milestone-0.md. They exist to be
# tuned at the checkpoint — change a number, press play, look at it.

const FOOTPRINT := 2.0        ## metres, square. Shared by every tier. Never varies.
const TIER_HEIGHT: Array[float] = [1.1, 2.0, 2.6]

const COUNTER_H := 0.70       ## elbow height on a 1.4 m Kithrin, so she can lean
const COUNTER_T := 0.12       ## counter slab thickness
const COUNTER_D := 0.50       ## how deep the counter juts back from the front edge
const POST := 0.16            ## corner post thickness
const ROOF_T := 0.18
const ROOF_OVER := 0.25       ## roof overhang past the footprint, per side
const WALL_T := 0.12

const TIER_COUNT := 3

## The stall faces -Z. The player approaches from there.
const HALF := FOOTPRINT * 0.5

var tier: int = 0:
	set(value):
		tier = clampi(value, 0, TIER_COUNT - 1)
		_apply_tier()

var _tiers: Array[Node3D] = []


func _ready() -> void:
	for t: int in TIER_COUNT:
		var holder := Node3D.new()
		holder.name = "Tier%d" % t
		add_child(holder)
		_tiers.append(holder)

	_build_tier_0(_tiers[0])
	_build_tier_1(_tiers[1])
	_build_tier_2(_tiers[2])
	_apply_tier()


## Tier 0 — a crate and a tarp. Below a Kithrin's eye line on purpose: this is
## the tier you stoop toward.
func _build_tier_0(root: Node3D) -> void:
	var h := TIER_HEIGHT[0]

	# The crate is the counter. No separate structure at this tier.
	_box(root, Vector3(FOOTPRINT * 0.9, COUNTER_H, COUNTER_D),
			Vector3(0.0, COUNTER_H * 0.5, -HALF + COUNTER_D * 0.5), Palette.WOOD_RAW)

	# Two poles at the back holding a tarp that slopes down toward the front.
	for side: float in [-1.0, 1.0]:
		_box(root, Vector3(0.09, h, 0.09),
				Vector3(side * (HALF - 0.15), h * 0.5, HALF - 0.15), Palette.WOOD_DARK)

	var tarp := _box(root, Vector3(FOOTPRINT, 0.05, FOOTPRINT * 0.8),
			Vector3(0.0, h - 0.12, 0.1), Palette.TARP)
	tarp.rotation_degrees.x = -9.0


## Tier 1 — timber frame, roof, lantern. Now a structure you stand under.
func _build_tier_1(root: Node3D) -> void:
	var h := TIER_HEIGHT[1]
	var post_h := h - ROOF_T

	_counter(root, Palette.WOOD)
	_posts(root, post_h)
	_roof(root, h, Palette.THATCH)

	# The lantern is tier 1's unlock made physical — "open into the evening".
	# It is geometry only for now; the OmniLight3D arrives with the evening,
	# at action-plan step 2.
	_box(root, Vector3(0.14, 0.22, 0.14),
			Vector3(-HALF + 0.3, post_h - 0.25, -HALF + 0.05), Palette.LANTERN)


## Tier 2 — proper shopfront. Enclosed, signed, and it has a storey on you.
func _build_tier_2(root: Node3D) -> void:
	var h := TIER_HEIGHT[2]
	var wall_h := h - ROOF_T

	_counter(root, Palette.WOOD)
	_posts(root, wall_h)
	_roof(root, h, Palette.ROOF_TILE)

	# Back and sides close in; the front stays open. This is what turns a frame
	# into a shopfront.
	_box(root, Vector3(FOOTPRINT, wall_h, WALL_T),
			Vector3(0.0, wall_h * 0.5, HALF - WALL_T * 0.5), Palette.PAINT_TRIM)
	for side: float in [-1.0, 1.0]:
		_box(root, Vector3(WALL_T, wall_h, FOOTPRINT),
				Vector3(side * (HALF - WALL_T * 0.5), wall_h * 0.5, 0.0), Palette.PAINT_TRIM)

	# Sign board, hung out front above the counter.
	_box(root, Vector3(FOOTPRINT * 0.7, 0.38, 0.07),
			Vector3(0.0, wall_h - 0.42, -HALF - 0.12), Palette.ACCENT)

	# Flowerbox at the foot of the counter. Two boxes: the trough and what's in it.
	_box(root, Vector3(FOOTPRINT * 0.8, 0.24, 0.28),
			Vector3(0.0, 0.12, -HALF - 0.18), Palette.WOOD_DARK)
	_box(root, Vector3(FOOTPRINT * 0.72, 0.14, 0.2),
			Vector3(0.0, 0.29, -HALF - 0.18), Palette.BLOOM)

	# Lantern carries over from tier 1 — nothing gained is ever lost.
	_box(root, Vector3(0.14, 0.22, 0.14),
			Vector3(-HALF + 0.3, wall_h - 0.25, -HALF + 0.05), Palette.LANTERN)


# --- Shared pieces --------------------------------------------------------

## A counter slab on the front edge, top at COUNTER_H.
func _counter(root: Node3D, colour: Color) -> void:
	_box(root, Vector3(FOOTPRINT * 0.9, COUNTER_T, COUNTER_D),
			Vector3(0.0, COUNTER_H - COUNTER_T * 0.5, -HALF + COUNTER_D * 0.5), colour)
	# A skirt under it, so the counter reads as built rather than floating.
	_box(root, Vector3(FOOTPRINT * 0.86, COUNTER_H - COUNTER_T, 0.1),
			Vector3(0.0, (COUNTER_H - COUNTER_T) * 0.5, -HALF + 0.05), Palette.WOOD_DARK)


func _posts(root: Node3D, post_h: float) -> void:
	for sx: float in [-1.0, 1.0]:
		for sz: float in [-1.0, 1.0]:
			_box(root, Vector3(POST, post_h, POST),
					Vector3(sx * (HALF - POST * 0.5), post_h * 0.5, sz * (HALF - POST * 0.5)),
					Palette.WOOD_DARK)


## Roof slab whose TOP sits exactly at the tier height — the number in the ladder
## is the silhouette height, not the underside.
func _roof(root: Node3D, h: float, colour: Color) -> void:
	var span := FOOTPRINT + ROOF_OVER * 2.0
	_box(root, Vector3(span, ROOF_T, span), Vector3(0.0, h - ROOF_T * 0.5, 0.0), colour)


## Every box in the stall goes through here, so every colour comes from Palette
## and collision is on by default — you should be able to walk up and be stopped.
func _box(root: Node3D, size: Vector3, pos: Vector3, colour: Color) -> CSGBox3D:
	var b := CSGBox3D.new()
	b.size = size
	b.position = pos
	b.material = Palette.solid(colour)
	b.use_collision = true
	root.add_child(b)
	return b


func _apply_tier() -> void:
	if _tiers.is_empty():
		return
	for i: int in _tiers.size():
		_tiers[i].visible = (i == tier)
