extends "res://game/menu/MenuScreenBase.gd"

func _on_Button_pressed():
	resolveScreen(Singletons.CHANGE_SCREEN, null, Singletons.menuScreens[Singletons.MATCH_SETUP])
