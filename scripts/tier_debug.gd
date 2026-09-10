extends Node

## TEMPORARY — DELETE WITH THE Debug CanvasLayer WHEN MILESTONE 0 CLOSES.
##
## The real loop now lives in `handover.gd`: walk up, press E three times, the
## night passes, the stall is better. Nothing here is part of that.
##
## `action-plan.md` step 4 says to delete the tier keys at this point, because
## tier must be driven by game state. Kept anyway for now, and the deviation is
## deliberate: the stall models are still being tuned, and jumping between tiers
## on demand is the tool for that. It is honest because the whole script goes at
## the end of the milestone — there is no path here that survives into the game.
##
##   1 / 2 / 3   jump to a tier, for comparing models while they are in flux
##   R           reset the run — tier 0, full basket, counter cleared

@export var stall_path: NodePath
@export var label_path: NodePath
@export var handover_path: NodePath

@onready var _stall: Stall = get_node(stall_path)
@onready var _label: Label = get_node(label_path)
@onready var _handover: Handover = get_node(handover_path)


func _process(_delta: float) -> void:
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
		KEY_R:
			_handover.reset()
		_:
			return


func _refresh() -> void:
	var hint := ""
	if _handover.can_give():
		hint = "E to give"
	elif _handover.stock <= 0:
		hint = "basket empty  ·  R to start over"
	elif _handover.on_counter >= Handover.COST:
		hint = "Tilly has all she needs  ·  R to start over"
	else:
		hint = "walk up to the counter"

	_label.text = "tier %d  ·  %.2f m  ·  basket %d  ·  counter %d/%d  ·  %s" % [
		_stall.tier, _stall.height_of(_stall.tier),
		_handover.stock, _handover.on_counter, Handover.COST, hint,
	]
