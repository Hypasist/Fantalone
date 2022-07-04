tool
extends TileMap

var _tiles_by_id = {
	0 : Resources.Grass,
	1 : Resources.Water,
	2 : Resources.Rocks
}
var _units_by_id = {
	0 : Resources.Ball,
	1 : Resources.Ball,
	2 : Resources.Ball,
	3 : Resources.Ball,
	4 : Resources.Ball,
	5 : Resources.Ball,
	6 : Resources.Ball,
	7 : Resources.Ball,
}

func consumeMockup():
	consume_tile_mockup()
	consume_unit_mockup()
	hide()

func get_used_ids(map:TileMap):
	var used_ids = {}
	var all_ids = map.tile_set.get_tiles_ids()
	for match_id in all_ids:
		var cells = map.get_used_cells_by_id(match_id)
		if cells: used_ids[match_id] = cells
	return used_ids

func consume_tile_mockup():
	var tile_mapping = get_used_ids($Tiles)
	for id in tile_mapping:
		var resource_name = _tiles_by_id[id]
		for coords in tile_mapping[id]:
			mod.Logic.add_new(resource_name, coords)

func consume_unit_mockup():
	var unit_mapping = get_used_ids($Units)
	for id in unit_mapping:
		var resource_name = _units_by_id[id]
		for coords in unit_mapping[id]:
			mod.Logic.add_new(resource_name, coords, id)

export (Vector2) var tilemapSize = Vector2(128, 70) setget updateTilemapSize
func updateTilemapSize(size):
	tilemapSize = size
	set_cell_size(size)
	$Tiles.set_cell_size(size)
	$Units.set_cell_size(size)
	$Props.set_cell_size(size)

#func coordsSquareToPosition(coordsSquare):
#	var tilePosition = Singletons.MapEditor.map_to_world(coordsSquare)
#	tilePosition += (Singletons.MapEditor.get_cell_size() / 2)
#	return tilePosition
#
#
