extends MenuScreenBase

func _ready():
	pass
func setup():
	pass

func _on_NewGame_pressed():
	mod.Menu.switch_screens(mod.Menu.singleplayer_setup)

func _on_CreateServer_pressed():
	mod.Network.create_server()
	mod.Menu.switch_screens(mod.Menu.multiplayer_setup)

func _on_ConnectToServer_pressed():
	mod.Network.connect_to_server()
	mod.Menu.switch_screens(mod.Menu.multiplayer_setup)
#	mod.Menu.switch_screens(mod.Menu.connect_to_server)
