class_name ButtonPlus
extends Button

var parent = null
var button_id = null
func setup(parent_, id_):
	parent = parent_
	button_id = id_
	set_v_size_flags(SIZE_EXPAND_FILL)
	set_h_size_flags(SIZE_EXPAND_FILL)
	connect("pressed", self, "_on_pressed")

signal button_pressed(parent, button_id)
func _on_pressed():
	emit_signal("button_pressed", parent, button_id)
