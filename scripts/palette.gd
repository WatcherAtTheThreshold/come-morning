extends RefCounted
class_name Palette

## Warm, lived-in, deliberately not pastel. Every colour in the game comes from
## here so the whole town can be re-graded by editing one file.
##
## Authored as sRGB hex. Godot treats StandardMaterial3D albedo as sRGB and
## converts internally, so what you type is what you see.
##
## Starting point only — re-grade freely once there is a stall to look at.

# --- Structure -------------------------------------------------------------
# The stall tier ladder in colour: rough crate wood → honest timber → painted
# shopfront. Tier 2 is the only tier allowed a saturated accent.
const WOOD_RAW     := Color("9a7048")   ## crates, pallets, tier 0
const WOOD         := Color("8a5c3a")   ## structural timber, tier 1 frame
const WOOD_DARK    := Color("6b4429")   ## posts, shadowed beams
const TARP         := Color("d8cbb0")   ## the tier 0 canvas — sun-bleached, tired
const THATCH       := Color("c2a05e")
const ROOF_TILE    := Color("a55f4a")   ## tier 2 — the roof that means "open in rain"
const PAINT_TRIM   := Color("4f7a6b")   ## tier 2 shopfront trim, muted green
const STONE        := Color("9a958a")
const STONE_LIGHT  := Color("b7b2a6")

# --- Ground and growth -----------------------------------------------------
const GRASS        := Color("6f9c46")
const GRASS_WORN   := Color("87a355")   ## the path worn by showing up
const DIRT         := Color("b08356")
const DIRT_DARK    := Color("8f6942")
const LEAF         := Color("5f9440")
const LEAF_LIGHT   := Color("7cae4c")
const BLOOM        := Color("d9748a")   ## the tier 2 flowerbox

# --- Goods -----------------------------------------------------------------
const MUSHROOM_CAP := Color("a06046")
const MUSHROOM_STEM := Color("e2d5bb")

# --- Light -----------------------------------------------------------------
## Two times of day, because the upgrade transition needs both ends of the
## fade. Morning is the payoff; evening is the pause that sells it.
const SUN_MORNING  := Color("fff2d6")
const SKY_MORNING  := Color("7fb8dd")
const HORIZON_MORNING := Color("f0e2cb")
const FOG_MORNING  := Color("cfe0e4")

const SUN_EVENING  := Color("ffb066")
const SKY_EVENING  := Color("3d4f78")
const HORIZON_EVENING := Color("e08a5c")
const FOG_EVENING  := Color("6f6a7a")

const LANTERN      := Color("ffc466")   ## tier 1's promise: open after dark
const ACCENT       := Color("e0a63c")   ## signage, markers, the tier 2 sign

## What the screen fades through on the way to morning. A deep indigo rather
## than black — black is an interruption, a night sky is a pause. The player
## should feel time passing, not feel the game stop.
const NIGHT        := Color("141a2e")

## The dark behind readable text. A near-black with the world's warmth in it
## rather than pure black, so text sits in the scene instead of on top of it.
const INK          := Color(0.09, 0.07, 0.06)


## A plain surface. Rough by default — a low roughness on an untextured
## primitive is most of what reads as "cheap plastic", so the default is matte.
static func solid(c: Color, rough: float = 0.9, metal: float = 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = c
	m.roughness = rough
	m.metallic = metal
	# A little specular even on matte surfaces keeps edges from going dead flat.
	m.specular_mode = BaseMaterial3D.SPECULAR_SCHLICK_GGX
	return m


## Same, but lit on both sides — for thin things like tarps and signage backing.
static func unshaded(c: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = c
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	return m
