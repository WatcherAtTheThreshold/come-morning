extends Node
class_name Handover

## The entire game in miniature: walk up, give what you gathered, and the night
## does the rest.
##
## Giving is one mushroom per press rather than a single transaction. The pitch
## is that a place gets better because you kept showing up, and three separate
## acts of giving say that where one confirmation button does not.
##
## It also means the counter *is* the progress indicator — you can see how close
## the upgrade is by looking at the stall, with no HUD and no number. That is the
## same instinct as "upgrades unlock access, not numbers".

const REACH := 2.2             ## metres, measured flat — height must not matter
const COST := 3                ## mushrooms per tier
const START_STOCK := 6         ## exactly both upgrades, nothing spare

## A beat after the last mushroom lands, before the light starts to go. Without
## it the third gift is placed and immediately swallowed by the fade, so the
## player never sees the thing they just did.
const BEAT_BEFORE_NIGHT := 0.7

## Where goods rest on the counter, per tier, in stall-local space. These are
## only a fallback: the moment a tier's .blend gains an empty named
## `CounterPoint`, that wins and these stop being consulted. Tune by eye.
const COUNTER_FALLBACK: Array[Vector3] = [
	Vector3(0.0, 0.74, -0.62),
	Vector3(0.0, 0.74, -0.62),
	Vector3(0.0, 0.78, -0.62),
]

## Three resting places so the second mushroom never lands inside the first, and
## three yaws so they read as set down rather than machine-placed. Deliberately
## fixed rather than random — a test you can repeat is worth more than variety.
const SLOT: Array[Vector3] = [
	Vector3(-0.21, 0.0, 0.04),
	Vector3(0.02, 0.0, -0.04),
	Vector3(0.20, 0.0, 0.05),
]
const SLOT_YAW: Array[float] = [18.0, -42.0, 71.0]

const MUSHROOM: PackedScene = preload("res://assets/props/mushroom.blend")

@export var stall_path: NodePath
@export var player_path: NodePath
@export var overnight_path: NodePath

@onready var _stall: Stall = get_node(stall_path)
@onready var _player: Node3D = get_node(player_path)
@onready var _overnight: Overnight = get_node(overnight_path)

var stock: int = START_STOCK
var on_counter: int = 0

var _placed: Array[Node3D] = []
var _busy := false


func _ready() -> void:
	reset()


func can_give() -> bool:
	return not _busy and stock > 0 and not at_last_tier() and in_reach()


func at_last_tier() -> bool:
	return _stall.tier >= Stall.TIER_COUNT - 1


## Flat distance. A counter is 0.74 m up and the player is 1.4 m tall; including
## the vertical would make reach depend on how tall the Kithrin happens to be.
func in_reach() -> bool:
	var here := _player.global_position
	var there := counter_point()
	return Vector2(here.x - there.x, here.z - there.z).length() <= REACH


func counter_point() -> Vector3:
	return _stall.to_global(_counter_point_local())


func reset() -> void:
	_busy = false
	stock = START_STOCK
	on_counter = 0
	_clear_placed()
	_stall.tier = 0


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return
	if not can_give():
		return

	stock -= 1
	on_counter += 1
	_place(on_counter - 1)

	if on_counter >= COST:
		_pass_the_night()


## The one sequence that matters. The tier changes and the goods disappear while
## the screen is dark — the player hands over mushrooms and wakes to a better
## stall, having watched neither the building nor the mushrooms being taken.
func _pass_the_night() -> void:
	_busy = true
	await get_tree().create_timer(BEAT_BEFORE_NIGHT).timeout

	await _overnight.fade_to_night()
	_stall.tier += 1
	_clear_placed()
	on_counter = 0
	await _overnight.fade_to_morning()

	_busy = false


func _place(index: int) -> void:
	var m := MUSHROOM.instantiate() as Node3D
	m.name = "given"
	# Readable serial names, so the scene tree says "given2" rather than
	# "@Node3D@3" when you go looking at what is sitting on the counter.
	_stall.add_child(m, true)
	m.position = _counter_point_local() + SLOT[index % SLOT.size()]
	m.rotation_degrees.y = SLOT_YAW[index % SLOT_YAW.size()]
	_placed.append(m)


## The model's own marker if it has one, otherwise the tuned constant. Adding a
## `CounterPoint` empty in Blender makes this switch over with no code change.
func _counter_point_local() -> Vector3:
	var tier_root := _stall.current_tier_node()
	if tier_root != null:
		var marker := tier_root.find_child("CounterPoint", true, false)
		if marker is Node3D:
			return _stall.to_local((marker as Node3D).global_position)
	return COUNTER_FALLBACK[_stall.tier]


func _clear_placed() -> void:
	for m: Node3D in _placed:
		if is_instance_valid(m):
			m.queue_free()
	_placed.clear()
