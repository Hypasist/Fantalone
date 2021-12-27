class_name Resources

const Ball = "Ball"

const Water = "Water"
const Rocks = "Rocks"
const Grass = "Grass"

# --- --- #
class KnownResource:
	var id_ = null
	var name_ = "invalid_resource_name"
	var logic_path = ""
	var display_path = ""
# --- --- #

var _tile_id = {
	0 : Grass,
	1 : Water,
	2 : Rocks
}

var _unit_id = {
	0 : Ball
}

