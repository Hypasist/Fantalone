extends Control

func setup(_title:String, _name:String, _color:Color):
	$Name.set_text(_title)
	$LineEdit.set_text(_name)
	$ColorFrame.set_frame_color(_color)

func set_color(_color:Color):
	$ColorFrame.set_frame_color(_color)
	
func get_current_color():
	return $ColorFrame.get_frame_color()
	
func get_current_name():
	return $LineEdit.get_text()


signal changeColor(object, value)

func _on_Left_pressed():
	emit_signal("changeColor", self, -1)

func _on_Right_pressed():
	emit_signal("changeColor", self, 1)
