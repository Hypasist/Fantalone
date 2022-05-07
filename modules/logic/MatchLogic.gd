extends Node

func start_match():
	mod.Menu.hide_menu()
	mod.MapView.setup()
	mod.UI.setup()
	mod.Database.set_current_turn_owner(0)
