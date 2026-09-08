extends Node

## TEMPORARY — DELETE AT ACTION-PLAN STEP 4.
##
## Delete this script, its node, and the Debug CanvasLayer when the handover
## lands. From then on the tier is driven by game state, and a leftover key that
## sets it directly is a debug path that will quietly outlive its usefulness.
##
## These keys are deliberately NOT registered in project.godot's input map. An
## input action survives the milestone; a doomed script cannot.

@export var stall_path: NodePath
@export var label_path: NodePath

@onready var _stall: Stall = get_node(stall_path)
@onready var _label: Label = get_node(label_path)


func _ready() -> void:
	_refresh()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return

	match key_event.physical_keycode:
		KEY_1:
			_stall.tier = 0
		KEY_2:
			_stall.tier = 1
		KEY_3:
			_stall.tier = 2
		_:
			return

	_refresh()


func _refresh() -> void:
	_label.text = "tier %d  ·  %.2f m  ·  1/2/3 to swap" % [
		_stall.tier, Stall.TIER_HEIGHT[_stall.tier]
	]
