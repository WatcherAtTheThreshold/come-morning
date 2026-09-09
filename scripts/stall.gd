extends Node3D
class_name Stall

## Tilly's stall. Three tiers, one visible at a time.
##
## The grey-box CSG this replaced lived here until 2026-09-09 and is in git if it
## is ever wanted back. Nothing outside this file changed when the real models
## arrived — `tier` is the seam, and the overnight sequence never knew the stall
## was made of boxes.
##
## All three tiers are instantiated once at _ready and hidden, rather than loaded
## on demand. Three stalls is a few thousand triangles, and a swap that cannot
## hitch is worth more than the memory, especially since the swap happens inside
## the night where a hitch would be invisible anyway.

const TIER_COUNT := 3

## Metres, square. Shared by every tier, never varies — it is the reserved plot,
## and it is what makes the swap read as growth in place rather than replacement.
const FOOTPRINT := 2.0

## One file per tier; the tier lives in the filename. Inside, every tier names its
## parts identically (the mesh is always `stall`), so nothing here has to branch.
const TIER_SCENE: Array[PackedScene] = [
	preload("res://assets/stalls/tilly-stall-t0.blend"),
	preload("res://assets/stalls/tilly-stall-t1.blend"),
	preload("res://assets/stalls/tilly-stall-t2.blend"),
]

## Blender's -Y front becomes Godot's +Z, so the models arrive facing away from a
## player walking in down -Z. If a re-export ever flips this, it is one number.
const MODEL_YAW := 180.0

var tier: int = 0:
	set(value):
		tier = clampi(value, 0, TIER_COUNT - 1)
		_apply_tier()

var _tiers: Array[Node3D] = []
var _heights: Array[float] = []


func _ready() -> void:
	for t: int in TIER_COUNT:
		var inst := TIER_SCENE[t].instantiate() as Node3D
		inst.rotation_degrees.y = MODEL_YAW
		add_child(inst)
		_tiers.append(inst)
		_heights.append(_measure_height(inst))
	_apply_tier()


## Measured from the model rather than declared in a table, so the number can
## never disagree with the thing on screen. Heights are a per-stall design choice
## now, not a fixed ladder — see "What actually changes between tiers" in
## docs/design/milestone-0.md.
func height_of(t: int) -> float:
	if t < 0 or t >= _heights.size():
		return 0.0
	return _heights[t]


func _measure_height(root: Node3D) -> float:
	var to_local := global_transform.affine_inverse()
	var top := 0.0
	for n: Node in _descendants(root):
		if n is MeshInstance3D:
			var mi := n as MeshInstance3D
			var box := (to_local * mi.global_transform) * mi.get_aabb()
			top = maxf(top, box.end.y)
	return top


func _descendants(n: Node) -> Array[Node]:
	var out: Array[Node] = [n]
	for c: Node in n.get_children():
		out.append_array(_descendants(c))
	return out


func _apply_tier() -> void:
	if _tiers.is_empty():
		return
	for i: int in _tiers.size():
		_tiers[i].visible = (i == tier)
