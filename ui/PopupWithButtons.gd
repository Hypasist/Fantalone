class_name PopupWithButtons
extends PopupBase

var button_list = []

func setup(parent:Object, text:String="", size:Vector2=Vector2(0,0)):
	.setup(parent, text, size)

func _ready():
	pass
	

const anchor_margin_between_buttons = 0.1
func add_button(number_of_buttons = 0, text_list:Array=[], object_list:Array=[], method_list:Array=[]):
	var handled_buttons_number = [text_list.size(), object_list.size(), method_list.size()].min()
	number_of_buttons = clamp(number_of_buttons, 0, handled_buttons_number)
	var relative_button_size = Vector2(1 - anchor_margin_between_buttons*(number_of_buttons+1), 0.1)
	for i in number_of_buttons:
		var button = Button.new()
		button.text = text_list[i]
		button.connect("pressed", object_list[i], method_list[i])
		
		var anchor_x = Vector2((anchor_margin_between_buttons + relative_button_size.x)*i + anchor_margin_between_buttons, \
		(anchor_margin_between_buttons + relative_button_size.x)*(i+1))
		var anchor_y = Vector2(0.80, 0.95)
		set_anchors_by_anchors(button, anchor_x, anchor_y)
		
		button_list.append(button)
		add_child(button)
