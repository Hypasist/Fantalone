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

func new_turn():
	.new_turn()
	var match_id = mod.ClientData.MatchData.get_turn_owner()
	var color = mod.ClientData.LobbyData.get_player_by_match_id(match_id).color
	mod.Popups.create_splash_popup(color)
