class_name ClientMatchData
extends MatchData

func start_match(package:Dictionary={}):
	mod.Menu.hide_menu()
	mod.GameUI.set_UI_mode(GameUI.UI_MODE_UNIT)
	setup(package)
	mod.Graphics.setup_graphics()
	mod.MapView.setup_map()
	mod.GameUI.setup()

func stop_match():
	Terminal.add_log(Debug.INFO, Debug.MATCH, "Match stopped.")
	mod.GameUI.set_UI_action(GameUI.UI_ACTION_NONE)
	mod.GameUI.set_UI_mode(GameUI.UI_MODE_MENU)
	mod.GameUI.hide_match_ui()
	mod.NetworkData.disconnect_self()
	mod.Menu.switch_screens(mod.Menu.main_menu)
