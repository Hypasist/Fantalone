extends Node

var loaded_resources = {}

class KnownResource:
	var name_ = "invalid_resource_name"
	var logic_path = ""
	var logic_scene = null
	var display_path = ""
	var display_scene = null
	
	func _init(name__:String, res:Array, logic_only:bool=false):
		name_ = name__
		logic_path = res[0]
		logic_scene = load(logic_path)
		if not logic_scene:
			Terminal.add_log(Debug.ERROR, Debug.MAP, "Invalid logic scene for %s resource!" % name_)
		if not logic_only:
			display_path = res[1]
			display_scene = load(display_path)
			Terminal.add_log(Debug.ALL, Debug.MAP, "Loaded %s!" % display_path)
			if not display_scene:
				Terminal.add_log(Debug.ERROR, Debug.MAP, "Invalid display scene for %s resource!" % name_)

		#NAME				#LOGIC SCENE								#DISPLAY SCENE
var _resources = {
	Resources.Grass	:		["res://modules/resources_logic/Grass.gd",	"res://modules/resources_display/Grass.tscn"],
	Resources.Water	:		["res://modules/resources_logic/Water.gd",	"res://modules/resources_display/Water.tscn"],
	Resources.Rocks	:		["res://modules/resources_logic/Rocks.gd",	"res://modules/resources_display/Rocks.tscn"],
	Resources.Ball	:		["res://modules/resources_logic/Ball.gd",	"res://modules/resources_display/Ball.tscn"],
	Resources.EffectDead:	["res://modules/data/effects/EffectDead.gd", ""],
	Resources.EffectFrozen:	["res://modules/data/effects/EffectFrozen.gd", ""],
	Resources.EffectTired:	["res://modules/data/effects/EffectTired.gd", ""],
}

func get_resource(name):
	if not loaded_resources.has(name):
		loaded_resources[name] = KnownResource.new(name, _resources[name])
	return loaded_resources[name]
