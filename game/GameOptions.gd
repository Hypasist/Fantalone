class_name GameOptions
extends Node

var game_options = {
	"tile_size" : Vector2(128, 70),
	"autofinish_turn" : true
	}

func is_autofinish_turn():
	return game_options["autofinish_turn"]