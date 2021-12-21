extends Node2D

	
func setup():
	loadMap()
	
func loadMap(savefile:String = ""):
	if savefile == "":
		mod.MapEditor.consumeMockup()

func add_tile_resource(resource):
	$Tiles.add_child(resource)
	
func add_unit_resource(resource):
	$Units.add_child(resource)

