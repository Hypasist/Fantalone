extends Node

onready var game_resolution = get_viewport().size

func setup():
	Singletons.GameOptions.set_game_resolution(game_resolution)
	Singletons.Worldview.setup()
	Singletons.Worldmap.setup()