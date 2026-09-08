extends Node3D

## The grey-box checkpoint scene — action-plan step 1.
##
## Sky, sun and ground colours are assigned here from Palette rather than saved
## into the .tscn, so the whole scene re-grades from one file. The .tscn holds
## structure only.
##
## The sun is deliberately morning-side. Come Morning's payoff moment is a
## morning, and evaluating the tier ladder under any other light is evaluating
## the wrong picture.

const SUN_ANGLE := Vector3(-42.0, 128.0, 0.0)  ## degrees — low and from behind-left
const SUN_ENERGY := 1.15

@onready var _world_env: WorldEnvironment = $Environment
@onready var _sun: DirectionalLight3D = $Sun
@onready var _ground: CSGBox3D = $Ground


func _ready() -> void:
	_sun.rotation_degrees = SUN_ANGLE
	_sun.light_color = Palette.SUN_MORNING
	_sun.light_energy = SUN_ENERGY

	_ground.material = Palette.solid(Palette.GRASS)

	var env := _world_env.environment
	var sky_material := env.sky.sky_material as ProceduralSkyMaterial
	sky_material.sky_top_color = Palette.SKY_MORNING
	sky_material.sky_horizon_color = Palette.HORIZON_MORNING
	sky_material.ground_horizon_color = Palette.HORIZON_MORNING
	sky_material.ground_bottom_color = Palette.GRASS

	env.fog_light_color = Palette.FOG_MORNING
