extends Node2D

var grid : HEXGrid = null

func setup():
	grid = HEXGrid.new(Singletons.GameOptions.game_options["tile_size"])

func loadMap(savefile:String = ""):
	if savefile == "":
		consumeCurrentTileMockup()
		calculateMockupSize()
		consumeCurrentActorMockup()
	
func consumeCurrentActorMockup():
	var actorTable = Singletons.MapEditor.getActorTable()
	for actorRecord in actorTable:
		var actorScene = actorRecord["scene"]
		if Singletons.MatchOptions.match_options["players"].has(actorRecord["player_id"]) == false:
			continue
		var player = Singletons.MatchOptions.match_options["players"][actorRecord["player_id"]]
		
		for coordsSquare in actorRecord["positionList"]:
			var actor = actorScene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
			actor.setup({	"overseer"	:	self,
							"HEXgrid"	:	grid,
							"coords"	:	coordsSquare,
							"color"		:	player["color"],
							"owner"		:	player["control"]})
			$Actors.add_child(actor)
			grid.addHEX(coordsSquare, actor)
			actor.add_to_group(player["unit_group_name"])

func calculateMockupSize():
	pass
	
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
