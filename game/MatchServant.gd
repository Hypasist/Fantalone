extends Node

func setup():
	pass

func start_game():
	Singletons.Worldmap.loadMap()
	Singletons.Logic.startMatch()