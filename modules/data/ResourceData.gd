extends Node

class KnownResource:
	var id_ = null
	var name_ = "invalid_resource_name"
	var logic_path = ""
	var logic_scene = null
	var display_path = ""
	var display_scene = null
	
	func _init(id__:int, res:Array):
		id_ = id__
		name_ = res[0]
		logic_path = res[1]
		logic_scene = load(logic_path)
		if not logic_scene:
			print("INVALID LOGIC SCENE FOR ", id_, " : ", name_, " RESOURCE!")
			breakpoint
		display_path = res[2]
		display_scene = load(display_path)
		if not display_scene:
			print("INVALID DISPLAY SCENE FOR ", id_, " : ", name_, " RESOURCE!")
			breakpoint
		return self

		#NAME		#LOGIC SCENE								#DISPLAY SCENE
var recognizedTiles = {
	0 : ["Grass",	"res://modules/resources_logic/Grass.gd",	"res://modules/resources_display/Grass.tscn"],
	1 : ["Water",	"res://modules/resources_logic/Water.gd",	"res://modules/resources_display/Water.tscn"],
	2 : ["Rocks",	"res://modules/resources_logic/Rocks.gd",	"res://modules/resources_display/Rocks.tscn"]
}
var recognizedUnits = {
	0 : ["commonBall", "res://modules/resources_logic/Ball.gd", "res://modules/resources_display/Ball.tscn"]
}

func get_tile_resource(id):
	return KnownResource.new(id, recognizedTiles[id])
func get_unit_resource(id):
	return KnownResource.new(id, recognizedUnits[id])
