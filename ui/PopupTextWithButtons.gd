class_name PopupTextWithButtons
extends PopupBase

func setup(size:Vector2=Vector2(0,0)):
	.setup(size)
#	set_anchors_by_anchors($MarginContainer/HBoxContainer, Vector2(0.7, 0), Vector2(1,1))

func setup_text(text:String=""):
	$Box/RichTextLabel.set_text(text)

var button_list = []
const anchor_margin_between_buttons = 0.1
func add_buttons(text_list, close_list, parent_object, parent_method):
	for i in text_list.size():
		var button = ButtonPlus.new()
		button.setup(text_list[i], i, close_list[i])
		button.connect("button_pressed", self, "handle_pressed")
		if parent_object and parent_method:
			connect("button_pressed", parent_object, parent_method)
		button_list.append(button)
		$Box/HBoxContainer.add_child(button)

signal button_pressed(value)
func handle_pressed(value, close_popup):
	if close_popup:
		mod.PopupUI.pop_popup(self)
	emit_signal("button_pressed", value)
