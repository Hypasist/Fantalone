extends Control

enum { main_menu, singleplayer_setup, multiplayer_setup, connect_to_server }
var screen_list = {
	main_menu			: "res://modules/display/menu/MenuMain.tscn",
	singleplayer_setup	: "res://modules/display/menu/MenuSingleplayerMatchSetup.tscn",
	multiplayer_setup 	: "res://modules/display/menu/MenuMultiplayerMatchSetup.tscn",
	connect_to_server 	: "res://modules/display/menu/MenuConnectToServer.tscn"
	}

# MENU HANDLING
func show_main_menu():
	switch_screens(main_menu)
	mod.UI.lock_map_control()
	mod.MapView.hide()
	
func hide_menu():
	if current_screen:
		current_screen.hide()
		current_screen.queue_free()
	current_screen = null
	mod.UI.unlock_map_control()
	mod.MapView.show()

var current_screen = null
func switch_screens(screen):
	var new_screen = load(screen_list[screen]).instance()
	new_screen.connect("screen_resolved", self, "_on_screen_resolved")
	add_child(new_screen)
	new_screen.setup()
	
	if current_screen:
		current_screen.hide()
		current_screen.queue_free()
	current_screen = new_screen
