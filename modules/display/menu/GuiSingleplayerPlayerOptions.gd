class_name GuiSingleplayerPlayerOptions
extends Control

var taken = false

func _ready():
	clear()

func clear():
	taken = false
	$Box/PlayerName.set_editable(false)
	$Box/LeftColor.set_disabled(true)
	$Box/RightColor.set_disabled(true)
	
func setup(has_ownership:bool, _name:String="-- empty --", _color:Color=Color.transparent):
	clear()
	$Box/PlayerName.set_text(_name)
	$Box/Color.set_frame_color(_color)
	if has_ownership:
		$Box/PlayerName.set_editable(true)
		$Box/LeftColor.set_disabled(true)
		$Box/RightColor.set_disabled(true)


func set_color(_color:Color):
	$Box/Color.set_frame_color(_color)
	
func get_current_color():
	return $Box/Color.get_frame_color()
	
func get_current_name():
	return $Box/PlayerName.get_text()



signal change_color(object, value)

func _on_RightColor_pressed():
	emit_signal("change_color", self, 1)

func _on_LeftColor_pressed():
	emit_signal("change_color", self, -1)

