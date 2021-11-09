tool
extends TileMap

func consumeMockup():
	consumeTileMockup()
	consumeUnitMockup()
	hide()

func get_used_ids(map:TileMap):
	var used_ids = {}
	var all_ids = map.tile_set.get_tiles_ids()
	for id in all_ids:
		var cells = map.get_used_cells_by_id(id)
		if cells: used_ids[id] = cells
	return used_ids

func consumeTileMockup():
	var tile_mapping = get_used_ids($Tiles)
	for id in tile_mapping:
		var resource = mod.Database.get_tile_resource(id)
		for coords in tile_mapping[id]:
			var hex = mod.Logic.get_hex_by_coords(coords)
			var logic_scene = resource.logic_scene.new()
			hex.add_resource(logic_scene)
			var display_scene = resource.display_scene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
			hex.add_resource(display_scene)

func consumeUnitMockup():
	var unit_mapping = get_used_ids($Units)
	for id in unit_mapping:
		var resource = mod.Database.get_unit_resource(0)
		for coords in unit_mapping[id]:
			var hex = mod.Logic.get_hex_by_coords(coords)
			var logic_scene = resource.logic_scene.new(id)
			hex.add_resource(logic_scene)
			var display_scene = resource.display_scene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
			hex.add_resource(display_scene)

#	$Tiles.set_visible(false)
#	return returnTable
	
#	consumeCurrentTileMockup()
#	calculateMockupSize()
#	consumeCurrentUnitMockup()

#func coordsSquareToPosition(coordsSquare):
#	var tilePosition = Singletons.MapEditor.map_to_world(coordsSquare)
#	tilePosition += (Singletons.MapEditor.get_cell_size() / 2)
#	return tilePosition
	
#func consumeCurrentUnitMockup():
#	var unitTable = Singletons.MapEditor.getUnitTable()
#	for unitRecord in unitTable:
#		var unitScene = unitRecord["scene"]
#		if Singletons.MatchOptions.match_options["players"].has(unitRecord["player_id"]) == false:
#			continue
#		var player = Singletons.MatchOptions.match_options["players"][unitRecord["player_id"]]
#
#		for coordsSquare in unitRecord["positionList"]:
#			var unit = unitScene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
#			unit.setup({	"overseer"	:	self,
#							"HEXgrid"	:	grid,
#							"coords"	:	coordsSquare,
#							"color"		:	player["color"],
#							"owner"		:	player["control"]})
#			$Units.add_child(unit)
#			grid.addHEX(coordsSquare, unit)
#			unit.add_to_group(player["unit_group_name"])


func getUnitTable():
	var returnTable = []
#	for id in range(0, Singletons.MAX_PLAYER_NUM):
#		var unitScene = recognizedUnits["commonBall"] 
#		var unitHEXpositions = $Units.get_used_cells_by_id(id)
#		returnTable.push_back({"player_id"	:	id,
#							   "scene"	:	unitScene,
#							   "positionList"	:	unitHEXpositions})
#	$Units.set_visible(false)
	return returnTable

const recognizedProps = {
#	"Player":preload("res://actors/PlayerBall.tscn"),
#	"Enemy":preload("res://actors/EnemyBall.tscn")
}
func getPropsTable():
	var returnTable = []
	for i in recognizedProps.size():
		var key = recognizedProps.keys()[i]
		var propsScene = recognizedProps[key]
		var propsHEXpositions = $Props.get_used_cells_by_id(i)
		returnTable.push_back({"key"	:	key,
							   "scene"	:	propsScene,
							   "positionList"	:	propsHEXpositions})
	$Props.set_visible(false)
	return returnTable


export (Vector2) var tilemapSize = Vector2(128, 70) setget updateTilemapSize
func updateTilemapSize(size):
	tilemapSize = size
	set_cell_size(size)
	$Tiles.set_cell_size(size)
	$Units.set_cell_size(size)
	$Props.set_cell_size(size)