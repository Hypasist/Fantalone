extends MenuScreenBase

func _ready():
	$VersionLabel.set_text("Version: %s " % mod.Database.get_version())

func _on_NewGame_pressed():
	mod.Menu.switch_screens(mod.Menu.singleplayer_setup)

const as_server = true
const as_client = false

func _on_CreateServer_pressed():
	mod.Menu.switch_screens(mod.Menu.multiplayer_setup, as_server)

func _on_ConnectToServer_pressed():
	mod.Menu.switch_screens(mod.Menu.multiplayer_setup, as_client)
#	mod.Menu.switch_screens(mod.Menu.connect_to_server)

func _on_Options_pressed():
	mod.PopupUI.create_options_menu_popup()
