class_name GameOptions
extends Node

var game_options = {
	"tilesize" : Vector2(128, 70),
	"map_bounds_pad" : 100,
	"autofinish_turn" : true,
	"menu_width" : 0.15
	}

func get_tilesize():
	return game_options["tilesize"]
func get_map_bounds_pad():
	return Vector2(game_options["map_bounds_pad"], game_options["map_bounds_pad"])


func is_autofinish_turn():
	return game_options["autofinish_turn"]

func set_game_resolution(resolution):
	game_options["game_resolution"] = resolution
	game_options["map_resolution"] = Vector2(resolution.x * (1-game_options["menu_width"]), resolution.y)
	# tmp background is 1224x800

func get_map_resolution():
	return game_options["map_resolution"]

func get_game_resolution():
	return game_options["game_resolution"]
