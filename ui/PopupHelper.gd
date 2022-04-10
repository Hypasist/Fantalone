class_name PopupHelper

static func create_hanging_popup_with_confirmation(parent, text, button_text):
	var ClassScene =load("res://ui/PopupWithButtons.tscn")
	
	var popup = ClassScene.instance()
	var size = Vector2(0.6, 0.8)
	popup.setup(parent, text, Vector2(0.6, 0.8))
	popup.add_button(1, ["Confirm"], [popup], ["destroy"])

