extends MenuScreenBase

func _ready():
	$VersionLabel.set_text("Version: %s   \n" % mod.GameData.get_version())

func _on_NewGame_pressed():
	mod.Menu.switch_screens(mod.Menu.singleplayer_setup)

func _on_CreateServer_pressed():
	mod.Menu.switch_screens(mod.Menu.multiplayer_setup, true)

func _on_ConnectToServer_pressed():
	mod.Popups.create_connect_to_server_popup()

func _on_Options_pressed():
	mod.Popups.create_options_menu_popup()
