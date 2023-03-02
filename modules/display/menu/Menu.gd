class_name Menu
extends Control

enum { main_menu, singleplayer_setup, multiplayer_setup, connect_to_server }
var screen_list = {
	main_menu			: "res://modules/display/menu/MenuMain.tscn",
	singleplayer_setup	: "res://modules/display/menu/MenuSingleplayerMatchSetup.tscn",
	multiplayer_setup 	: "res://modules/display/menu/MenuMultiplayerMatchSetup.tscn",
	connect_to_server 	: "res://modules/display/menu/MenuConnectToServer.tscn"
	}

# MENU HANDLING
func hide_menu():
	if current_screen:
		current_screen.hide()
		current_screen.queue_free()
	current_screen = null
	mod.GameUI.unlock_map_control()
	mod.MapView.show()

func show_menu():
	if current_screen:
		current_screen.show()
	mod.GameUI.lock_map_control()
	mod.MapView.hide()

var previous_screen = null
var current_screen = null
func switch_screens(screen, setup_params=null):
	previous_screen = current_screen
	current_screen = load(screen_list[screen]).instance()
	current_screen.connect("screen_resolved", self, "_on_screen_resolved")
	add_child(current_screen)
	show_menu()
	current_screen.setup(setup_params)
	
	if previous_screen:
		previous_screen.hide()
		previous_screen.queue_free()

func _on_screen_resolved(package):
	pass

func refresh(refresh_level=0):
	current_screen.refresh(refresh_level)
