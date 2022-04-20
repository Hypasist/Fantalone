class_name ButtonPlus
extends Button

var signal_id = null
func setup(signal_id_):
	signal_id = signal_id_
	connect("pressed", self, "_on_pressed")

signal button_pressed(signal_id)
func _on_pressed():
	emit_signal("button_pressed", signal_id)
