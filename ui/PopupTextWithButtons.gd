class_name PopupTextWithButtons
extends PopupBase

var button_list = []

func setup(size:Vector2=Vector2(0,0)):
	.setup(size)
#	set_anchors_by_anchors($MarginContainer/HBoxContainer, Vector2(0.7, 0), Vector2(1,1))
	
func setup_text(text:String=""):
	$Box/RichTextLabel.set_text(text)

func _ready():
	pass
	
const anchor_margin_between_buttons = 0.1
func add_button(number_of_buttons=0, text_list:Array=[], object_list:Array=[], method_list:Array=[], id_list:Array=[]):
	var handled_buttons_number = [text_list.size(), object_list.size(), method_list.size()].min()
	number_of_buttons = clamp(number_of_buttons, 0, handled_buttons_number)
	var relative_button_size = Vector2(1 - anchor_margin_between_buttons*(number_of_buttons+1), 0.1)
	print("add_button")
	for i in number_of_buttons:
		var button = ButtonPlus.new()
		button.text = text_list[i]
		var signal_id = id_list[i] if id_list.size() > i and id_list[i] else button
		button.setup(self, signal_id)
		button.connect("button_pressed", object_list[i], method_list[i])
		button_list.append(button)
		$Box/HBoxContainer.add_child(button)
