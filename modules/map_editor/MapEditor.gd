tool
class_name MapEditor
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

func consume_mockup():
	consume_tile_mockup()
	var match_ids = []
	for player in mod.LobbyData.get_players():
		match_ids.append(player.match_id)
	consume_unit_mockup(match_ids)
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
			mod.ObjectData.create_new_object(resource_name, coords)

func consume_unit_mockup(players):
	var unit_mapping = get_used_ids($Units)
	for match_id in unit_mapping:
		if players.has(match_id):
			var resource_name = _units_by_id[match_id]
			for coords in unit_mapping[match_id]:
				mod.ObjectData.create_new_object(resource_name, coords, match_id)

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
