extends CanvasLayer
class_name Overnight

## The signature moment. Hand over goods, the day closes, and come morning the
## stall is different — the player never watches the building happen.
##
## This owns the time of day. Nothing else should touch the sun or the sky, so
## that "what time is it" has exactly one answer and one place to change.
##
## Used as two awaitable halves, so the caller reads as the sequence it is:
##
##     await overnight.fade_to_night()
##     stall.tier += 1                  # never seen — the screen is dark
##     await overnight.fade_to_morning()
##
## The tier change goes BETWEEN them on purpose. An instant mesh swap reads as
## a bug; the same swap hidden inside a night reads as the Kithrin having been
## busy while you slept. This is cheaper than any build animation and does more
## emotional work.

# --- Pacing. These are the whole tuning surface. --------------------------
const DUSK_TIME := 1.6      ## day draining to dark. The light warms as it goes.
const NIGHT_TIME := 0.9     ## how long the dark is held. The work happens here.
const DAWN_TIME := 2.0      ## slower than dusk — the payoff is allowed to linger.

## DO NOT SIMPLIFY THIS TO A COLOUR FADE.
##
## The sun *rotates* between these two angles, which sweeps every shadow in the
## scene across the ground. At the 2026-09-08 checkpoint that movement turned
## out to be doing the work: Jessop deliberately looked away during the
## transition and still registered it, because a travelling shadow reads
## peripherally in a way a screen dimming does not.
##
## Dropping the rotation and keeping only colour and energy would look nearly
## identical in a screenshot and lose most of the effect in motion.
const SUN_ANGLE_MORNING := Vector3(-42.0, 128.0, 0.0)
const SUN_ANGLE_EVENING := Vector3(-8.0, 196.0, 0.0)   ## low and swung west
const SUN_ENERGY_MORNING := 1.15
const SUN_ENERGY_EVENING := 0.55

@export var sun_path: NodePath
@export var world_environment_path: NodePath

@onready var _overlay: ColorRect = $Overlay
@onready var _sun: DirectionalLight3D = get_node(sun_path)
@onready var _world_env: WorldEnvironment = get_node(world_environment_path)

var _sky_material: ProceduralSkyMaterial
var _running := false


func _ready() -> void:
	_sky_material = _world_env.environment.sky.sky_material as ProceduralSkyMaterial
	_overlay.color = Color(Palette.NIGHT, 0.0)
	set_time_of_day(0.0)


func is_running() -> bool:
	return _running


## Day drains to dark. The light warms and drops toward the horizon as it goes,
## so the evening is *lit* differently rather than merely dimmer — a screen that
## only darkens reads as a fade-out, not as a sunset.
func fade_to_night() -> void:
	if _running:
		return
	_running = true

	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_method(set_time_of_day, 0.0, 1.0, DUSK_TIME)
	tween.parallel().tween_property(_overlay, "color:a", 1.0, DUSK_TIME)
	tween.tween_interval(NIGHT_TIME)
	await tween.finished


## Morning. The world is relit before the overlay lifts, so the first thing the
## player sees is already the new day — never a cross-fade between two states.
func fade_to_morning() -> void:
	set_time_of_day(0.0)

	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_overlay, "color:a", 0.0, DAWN_TIME)
	await tween.finished

	_running = false


## 0.0 is morning, 1.0 is evening. Every colour comes from Palette, so the whole
## day re-grades from one file.
func set_time_of_day(t: float) -> void:
	_sun.light_color = Palette.SUN_MORNING.lerp(Palette.SUN_EVENING, t)
	_sun.light_energy = lerpf(SUN_ENERGY_MORNING, SUN_ENERGY_EVENING, t)
	_sun.rotation_degrees = SUN_ANGLE_MORNING.lerp(SUN_ANGLE_EVENING, t)

	_sky_material.sky_top_color = Palette.SKY_MORNING.lerp(Palette.SKY_EVENING, t)
	_sky_material.sky_horizon_color = Palette.HORIZON_MORNING.lerp(Palette.HORIZON_EVENING, t)
	_sky_material.ground_horizon_color = Palette.HORIZON_MORNING.lerp(Palette.HORIZON_EVENING, t)

	_world_env.environment.fog_light_color = Palette.FOG_MORNING.lerp(Palette.FOG_EVENING, t)
