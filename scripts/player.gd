extends CharacterBody3D
class_name Player

## Placeholder capsule for milestone 0. Walks, looks, and nothing else — there is
## no jump because there is nothing to jump over, and there will never be an
## attack.
##
## Speeds are set for a 1.4 m body. A human-scale 4 m/s here would read as a
## scurrying rodent, because the number that matters is body-lengths per second,
## not metres.

const HEIGHT := 1.4           ## matches CLAUDE.md → Scale
const SPEED := 2.4            ## m/s — a walk, not a jog
const ACCEL := 14.0
const MOUSE_SENS := 0.0022

const CAM_PITCH_START := deg_to_rad(-6.0)
const CAM_PITCH_MIN := deg_to_rad(-28.0)
const CAM_PITCH_MAX := deg_to_rad(24.0)  ## enough to look up at a tier 2 roofline

@onready var _pivot: Node3D = $CamPivot


func _ready() -> void:
	_pivot.rotation.x = CAM_PITCH_START
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var motion := event as InputEventMouseMotion
		rotate_y(-motion.relative.x * MOUSE_SENS)
		_pivot.rotation.x = clampf(
				_pivot.rotation.x - motion.relative.y * MOUSE_SENS,
				CAM_PITCH_MIN, CAM_PITCH_MAX)
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var dir := (transform.basis * Vector3(input.x, 0.0, input.y)).normalized()
	var target := dir * SPEED

	velocity.x = move_toward(velocity.x, target.x, ACCEL * delta)
	velocity.z = move_toward(velocity.z, target.z, ACCEL * delta)

	move_and_slide()
