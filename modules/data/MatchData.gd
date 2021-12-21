extends Node

var item_list = {}

func report_new_object(class_):
	var class_name_ = class_._get_bundled_scene()["names"][0]
	if item_list.has(class_name_):
		item_list[class_name_] = item_list[class_name_] + 1
	else:
		item_list[class_name_] = 0
	return "%s_%03d" % [class_name_, item_list[class_name_]]

#func consumeCurrentUnitMockup():
#	var unitTable = Singletons.MapEditor.getUnitTable()
#	for unitRecord in unitTable:
#		var unitScene = unitRecord["scene"]
#		if Singletons.MatchOptions.match_options["players"].has(unitRecord["player_id"]) == false:
#			continue
#		var player = Singletons.MatchOptions.match_options["players"][unitRecord["player_id"]]
#
#		for coordsSquare in unitRecord["positionList"]:
#			var unit = unitScene.
#			unit.setup({	"overseer"	:	self,
#							"HEXgrid"	:	grid,
#							"coords"	:	coordsSquare,
#							"color"		:	player["color"],
#							"owner"		:	player["control"]})
#			$Units.add_child(unit)
#			grid.addHEX(coordsSquare, unit)
#
#func calculateMockupSize():
#	var minHexCoords = Vector2(INF, INF)
#	var maxHexCoords = Vector2(-INF, -INF)
#	for tile in get_tree().get_nodes_in_group("Tiles"):
#		minHexCoords = Utils.min2(minHexCoords, tile.position)
#		maxHexCoords = Utils.max2(maxHexCoords, tile.position)
#	minHexCoords -= Singletons.GameOptions.get_tilesize()/2.0 \
#	 				+ Singletons.GameOptions.get_map_bounds_pad()
#	maxHexCoords += Singletons.GameOptions.get_tilesize()/2.0 \
#	 				+ Singletons.GameOptions.get_map_bounds_pad()
#	Singletons.MatchOptions.set_map_boundaries(minHexCoords, maxHexCoords)
#
#func consumeCurrentTileMockup():
#	var tileTable = Singletons.MapEditor.getTileTable()
#	for tileRecord in tileTable:
#		var tileScene = tileRecord["scene"]
#		for coordsSquare in tileRecord["positionList"]:
#			var tile = tileScene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
#			tile.setup({	"overseer"	:	self,
#							"HEXgrid"	:	grid,
#							"coords"	:	coordsSquare})
#			$Tiles.add_child(tile)
#			grid.addHEX(coordsSquare, tile)
#
#func coordsSquareToPosition(coordsSquare):
#	var tilePosition = Singletons.MapEditor.map_to_world(coordsSquare)
#	tilePosition += (Singletons.MapEditor.get_cell_size() / 2)
#	return tilePosition
#
#
