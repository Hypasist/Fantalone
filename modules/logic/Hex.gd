class_name Hex
extends Reference

var tile_logic : TileLogicBase = null
var unit_logic : UnitLogicBase = null
#var prop : PropBase = null
var coords : HexCoords = null


func _init(coords_):
	if coords_ is Vector2: coords = HexCoords.new(coords_.x, coords_.y)
	if coords_ is Array: coords = HexCoords.new(coords_[0], coords_[1])
	if coords_ is HexCoords: coords = HexCoords.new(coords_.q, coords_.r)
#	if tile_ is TileBase: tile = tile_.new()
#	if unit_ is UnitBase: unit = unit_.new()
#	if prop_ is PropBase: prop = prop_.new()

func place_unit(unit_instance):
	if unit_instance is UnitLogicBase:
		unit_logic = unit_instance.place(self)
func get_unit():
	return unit_logic
func place_tile(tile_instance):
	if tile_instance is TileLogicBase:
		tile_logic = tile_instance.place(self)
func get_tile():
	return tile_logic
	
func is_taken():
	return (unit_logic != null)
func is_passable():
	return tile_logic.passable if tile_logic else false
func is_lethal():
	return tile_logic.lethal if tile_logic else false
func get_owner():
	return unit_logic.get_owner() if unit_logic else null
func get_neighbour(direction):
	return mod.Logic.get_neighbour_hex(self, direction)
func get_coords():
	return coords
func pack():
	var pack = {}
	pack["q"] = coords.q
	pack["r"] = coords.r
	return pack
