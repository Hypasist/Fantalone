extends Node2D
onready var tilemap = $"../MapEditor"
onready var eventlog = $"../../UI/EventLog"
onready var mockup = $"../MapEditor"

var grid : HEXGrid = null

func addLog(string:String):
	eventlog.addLog(string)

func _ready():
	grid = HEXGrid.new(tilemap.get_cell_size())
	loadMap()

func loadMap(savefile:String = ""):
	if savefile == "":
		consumeCurrentTileMockup()
		consumeCurrentActorMockup()
	
func consumeCurrentActorMockup():
	var actorTable = mockup.getActorTable()
	for actorRecord in actorTable:
		var actorScene = actorRecord["scene"]
		
		for coordsSquare in actorRecord["positionList"]:
			var actor = actorScene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
			actor.setup({	"overseer"	:	self,
							"HEXgrid"	:	grid,
							"coords"	:	coordsSquare,
							"logger"	:	eventlog})
			$Actors.add_child(actor)
			grid.addHEX(coordsSquare, actor)

func consumeCurrentTileMockup():
	var tileTable = mockup.getTileTable()
	for tileRecord in tileTable:
		var tileScene = tileRecord["scene"]
		for coordsSquare in tileRecord["positionList"]:
			var tile = tileScene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
			tile.setup({	"overseer"	:	self,
							"HEXgrid"	:	grid,
							"coords"	:	coordsSquare,
							"logger"	:	eventlog})
			$Tiles.add_child(tile)
			grid.addHEX(coordsSquare, tile)

func coordsSquareToPosition(coordsSquare):
	var tilePosition = tilemap.map_to_world(coordsSquare)
	tilePosition += (tilemap.get_cell_size() / 2)
	return tilePosition


# --- objects hovered --- #
var hoverlist = []
func add_to_hoverlist(object):
	if !hoverlist.has(object):
		hoverlist.append(object)

func remove_from_hoverlist(object):
	if hoverlist.has(object):
		hoverlist.erase(object)
