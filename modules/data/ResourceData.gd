class_name ResourceData
extends Node

const _LOGIC_SCENE_PATH = 0
const _DISPLAY_SCENE_PATH = 1

var loaded_resources = {}

class KnownResource:
	var name_ = "invalid_resource_name"
	var logic_path = ""
	var logic_scene = null
	var display_path = ""
	var display_scene = null
	
	func _init(name__:String, res:Array, logic_only:bool=false):
		name_ = name__
		logic_path = res[_LOGIC_SCENE_PATH]
		logic_scene = load(logic_path)
		if not logic_scene:
			Terminal.add_log(Debug.ERROR, Debug.MAP, "Invalid logic scene for %s resource!" % name_)
		if not logic_only and not res[_DISPLAY_SCENE_PATH] == "":
			display_path = res[_DISPLAY_SCENE_PATH]
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
	Resources.Icecube:		["res://modules/resources_logic/Icecube.gd","res://modules/resources_display/Icecube.tscn"],
	Resources.EffectDead:	["res://modules/data/effects/EffectDead.gd", ""],
	Resources.EffectFrozen:	["res://modules/data/effects/EffectFrozen.gd", ""],
	Resources.EffectTired:	["res://modules/data/effects/EffectTired.gd", ""],
	Resources.EffectShortlived:["res://modules/data/effects/EffectShortlived.gd", ""],
}

func is_loaded(name, logic_only):
	if loaded_resources.has(name):
		if logic_only:
			return loaded_resources[name].logic_scene
		else:
			return loaded_resources[name].display_scene
	else:
		return false

func get_resource(name, logic_only=false):
	if not is_loaded(name, logic_only):
		loaded_resources[name] = KnownResource.new(name, _resources[name], logic_only)
	return loaded_resources[name]
