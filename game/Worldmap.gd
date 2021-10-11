extends Node2D

var grid : HEXGrid = null

func setup():
	grid = HEXGrid.new(Singletons.GameOptions.game_options["tilesize"])

func loadMap(savefile:String = ""):
	if savefile == "":
		consumeCurrentTileMockup()
		calculateMockupSize()
		consumeCurrentUnitMockup()
	
func consumeCurrentUnitMockup():
	var unitTable = Singletons.MapEditor.getUnitTable()
	for unitRecord in unitTable:
		var unitScene = unitRecord["scene"]
		if Singletons.MatchOptions.match_options["players"].has(unitRecord["player_id"]) == false:
			continue
		var player = Singletons.MatchOptions.match_options["players"][unitRecord["player_id"]]
		
		for coordsSquare in unitRecord["positionList"]:
			var unit = unitScene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
			unit.setup({	"overseer"	:	self,
							"HEXgrid"	:	grid,
							"coords"	:	coordsSquare,
							"color"		:	player["color"],
							"owner"		:	player["control"]})
			$Units.add_child(unit)
			grid.addHEX(coordsSquare, unit)
			unit.add_to_group(player["unit_group_name"])

func calculateMockupSize():
	var minHexCoords = Vector2(INF, INF)
	var maxHexCoords = Vector2(-INF, -INF)
	for tile in get_tree().get_nodes_in_group("Tiles"):
		minHexCoords = Utils.min2(minHexCoords, tile.position)
		maxHexCoords = Utils.max2(maxHexCoords, tile.position)
	minHexCoords -= Singletons.GameOptions.get_tilesize()/2.0 \
	 				+ Singletons.GameOptions.get_map_bounds_pad()
	maxHexCoords += Singletons.GameOptions.get_tilesize()/2.0 \
	 				+ Singletons.GameOptions.get_map_bounds_pad()
	Singletons.MatchOptions.set_map_boundaries(minHexCoords, maxHexCoords)
	
func consumeCurrentTileMockup():
	var tileTable = Singletons.MapEditor.getTileTable()
	for tileRecord in tileTable:
		var tileScene = tileRecord["scene"]
		for coordsSquare in tileRecord["positionList"]:
			var tile = tileScene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
			tile.setup({	"overseer"	:	self,
							"HEXgrid"	:	grid,
							"coords"	:	coordsSquare})
			$Tiles.add_child(tile)
			grid.addHEX(coordsSquare, tile)

func coordsSquareToPosition(coordsSquare):
	var tilePosition = Singletons.MapEditor.map_to_world(coordsSquare)
	tilePosition += (Singletons.MapEditor.get_cell_size() / 2)
	return tilePosition


# --- objects hovered --- #
var hoverlist = []
func add_to_hoverlist(object):
	if !hoverlist.has(object):
		hoverlist.append(object)

func remove_from_hoverlist(object):
	if hoverlist.has(object):
		hoverlist.erase(object)
