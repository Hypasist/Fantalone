extends Node

onready var game_resolution = get_viewport().size

func setup():
	Singletons.Worldview.set_game_resolution(game_resolution)
	Singletons.Worldmap.setup()