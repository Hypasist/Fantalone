class_name ButtonPlus
extends Button

var button_value = null
var close_popup = false
func setup(text_, value, close=false):
	button_value = value
	close_popup = close
	set_text(text_)
	connect("pressed", self, "_on_pressed")

signal button_pressed(value, close)
func _on_pressed():
	emit_signal("button_pressed", button_value, close_popup)
