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

func execute_display_commands():
	var any_command_was_done = true
	while any_command_was_done:
		any_command_was_done = false
		for tile in $Tiles.get_children():
			pass
		for unit in $Units.get_children():
			any_command_was_done = any_command_was_done or unit.execute_command()
