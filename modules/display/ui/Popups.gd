class_name Popups
extends Control

func create_match_menu_popup():
	var ClassScene = load("res://ui/MatchMenuPopup.tscn")
	var popup = ClassScene.instance()
	add_child(popup)
	popup.setup(Vector2(0.4, 0.8))
	push_popup(popup)

func create_options_menu_popup():
	var ClassScene = load("res://ui/OptionsMenuPopup.tscn")
	var popup = ClassScene.instance()
	add_child(popup)
	popup.setup(Vector2(0.8, 0.6))
	push_popup(popup)

func create_spell_menu_popup():
	var ClassScene = load("res://ui/SpellMenuPopup.tscn")
	var popup = ClassScene.instance()
	add_child(popup)
	popup.setup(Vector2(0.8, 1.0))
	push_popup(popup)

func create_endscreen_popup():
	var ClassScene = load("res://ui/PopupEndScreen.tscn")
	var popup = ClassScene.instance()
	add_child(popup)
	popup.setup(Vector2(0.8, 0.6))
	push_popup(popup)

func create_connect_to_server_popup():
	var ClassScene = load("res://ui/ConnectToServerPopup.tscn")
	var popup = ClassScene.instance()
	add_child(popup)
	popup.setup(Vector2(0.8, 0.8))
	push_popup(popup)

func create_popup_with_confirmation(text, button_text):
	create_custom_popup(text, [button_text], [true])

func create_custom_popup(text, text_list:Array=[], close_list:Array=[], parent_object=null, parent_method=null):
	var ClassScene = load("res://ui/PopupTextWithButtons.tscn")
	var popup = ClassScene.instance()
	add_child(popup)
	popup.setup(Vector2(0.6, 0.8))
	popup.setup_text(text)
	popup.add_buttons(text_list, close_list, parent_object, parent_method)
	push_popup(popup)

func create_splash_popup(color):
	var ClassScene = load("res://ui/PopupSplash.tscn")
	var popup = ClassScene.instance()
	add_child(popup)
	popup.setup(Vector2(0.6, 0.8))
	popup.set_info(color)
	push_popup(popup, false)

var active_popups = []
func push_popup(popup, dim=true):
	if active_popups.empty():
		mod.GameUI.set_UI_mode(GameUI.UI_MODE_MENU)
		if dim:
			$Dim.show()
	else:
		active_popups[0].hide()
	active_popups.push_front(popup)

func pop_popup(popup):
	active_popups.erase(popup)
	popup.queue_free()
	if active_popups.empty():
		mod.GameUI.revert_UI_mode()
		$Dim.hide()
	else:
		active_popups[0].show()
