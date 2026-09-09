extends Node

## TEMPORARY — DELETE AT ACTION-PLAN STEP 4.
##
## Delete this script, its node, and the Debug CanvasLayer when the handover
## lands. From then on the tier is driven by game state, and a leftover key that
## sets it directly is a debug path that will quietly outlive its usefulness.
##
## What replaces it is narrow: step 4 swaps the N key for walking up and pressing
## E. The overnight sequence in _pass_night() is the real thing and moves across
## unchanged — only the trigger is scaffolding.
##
## These keys are deliberately NOT registered in project.godot's input map. An
## input action survives the milestone; a doomed script cannot.
##
##   1 / 2 / 3   jump straight to a tier, for comparing them side by side
##   N           spend the night and come up one tier — the actual moment

@export var stall_path: NodePath
@export var label_path: NodePath
@export var overnight_path: NodePath

@onready var _stall: Stall = get_node(stall_path)
@onready var _label: Label = get_node(label_path)
@onready var _overnight: Overnight = get_node(overnight_path)


func _ready() -> void:
	_refresh()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	if _overnight.is_running():
		return

	match key_event.physical_keycode:
		KEY_1:
			_stall.tier = 0
		KEY_2:
			_stall.tier = 1
		KEY_3:
			_stall.tier = 2
		KEY_N:
			_pass_night()
			return
		_:
			return

	_refresh()


## The sequence, spelled out in the order it happens. The tier changes while the
## screen is dark, so the swap itself is never on screen — that is the whole
## trick, and it is three lines.
func _pass_night() -> void:
	if _stall.tier >= Stall.TIER_COUNT - 1:
		return

	await _overnight.fade_to_night()
	_stall.tier += 1
	_refresh()
	await _overnight.fade_to_morning()


func _refresh() -> void:
	var hint := "N to spend the night" if _stall.tier < Stall.TIER_COUNT - 1 else "1 to start over"
	_label.text = "tier %d  ·  %.2f m  ·  %s" % [
		_stall.tier, _stall.height_of(_stall.tier), hint
	]
