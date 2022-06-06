extends Control

func create_match_menu_popup():
	var ClassScene = load("res://ui/MatchMenuPopup.tscn")
	var popup = ClassScene.instance()
	popup.setup(Vector2(0.4, 0.8))
	push_popup(popup)

func create_popup_with_confirmation(text, button_text):
	create_custom_popup(text, 1, button_text, [mod.PopupUI], ["free_popup"], [null])

func create_custom_popup(text, number_of_buttons=0, text_list:Array=[], object_list:Array=[], method_list:Array=[], id_list:Array=[]):
	var ClassScene = load("res://ui/PopupTextWithButtons.tscn")
	var popup = ClassScene.instance()
	popup.setup(Vector2(0.6, 0.8))
	popup.setup_text(text)
	popup.add_button(number_of_buttons, text_list, object_list, method_list, id_list)
	push_popup(popup)
	return popup

func push_popup(popup):
	if active_popups.empty():
		$Dim.show()
	else:
		active_popups[0].hide()
	active_popups.push_front(popup)
	add_child(popup)

func pop_popup(object):
	active_popups.erase(object)
	object.queue_free()
	
	if active_popups.empty():
		$Dim.hide()
	else:
		active_popups[0].show()

var active_popups = []
func free_popup(object, id=null):
	if active_popups.has(object):
		pop_popup(object)
