extends Control

func add_temporary_popup(object):
	add_child(object)

func add_hanging_popup(object, is_dimmed=false):
	add_child(object)
	if is_dimmed:
		$Dim.show()
	else:
		$Dim.hide()



func create_hanging_popup_with_confirmation(text, button_text):
	var ClassScene = load("res://ui/PopupWithButtons.tscn")
	var popup = ClassScene.instance()
	var size = Vector2(0.6, 0.8)
	popup.setup(text, Vector2(0.6, 0.8))
	popup.add_button(1, ["Confirm"], [mod.PopupHelper], ["free_popup"], [popup])
	active_popups.append(popup)
	add_child(popup)
	$Dim.show()

var active_popups = []
func free_popup(object):
	if active_popups.has(object):
		active_popups.erase(object)
		object.queue_free()
	if active_popups.empty():
		$Dim.hide()
