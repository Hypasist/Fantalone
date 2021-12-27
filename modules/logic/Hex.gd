class_name Hex
extends Reference

var tileLogic : TileLogicBase = null
var unitLogic : UnitLogicBase = null
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
		unitLogic = unit_instance.place(self)
func get_unit():
	return unitLogic
func place_tile(tile_instance):
	if tile_instance is TileLogicBase:
		tileLogic = tile_instance.place(self)
func get_tile():
	return tileLogic
	
func is_taken():
	return (unitLogic != null)
func is_passable():
	return tileLogic.passable if tileLogic else false
func is_lethal():
	return tileLogic.lethal if tileLogic else false
func get_owner():
	return unitLogic.get_owner() if unitLogic else null
func get_neighbour(direction):
	return mod.Logic.get_neighbour_hex(self, direction)
func get_coords():
	return coords
