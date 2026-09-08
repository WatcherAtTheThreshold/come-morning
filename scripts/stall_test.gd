extends Node3D

## The grey-box checkpoint scene — action-plan steps 1 and 2.
##
## Deliberately thin. Time of day belongs to overnight.gd and the stall belongs
## to stall.gd; all that is left here is the ground the whole thing stands on.
##
## Colours are assigned at runtime from Palette rather than saved into the .tscn,
## so the scene re-grades from one file.

@onready var _ground: CSGBox3D = $Ground


func _ready() -> void:
	_ground.material = Palette.solid(Palette.GRASS)
