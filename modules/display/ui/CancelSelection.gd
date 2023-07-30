extends Button

func _ready():
	pass # Replace with function body.

func update():
	set_visible(mod.ControllerData.any_unit_selected())
	#set_disabled(not mod.ControllerData.any_unit_selected())

func _on_CancelSelection_pressed():
	mod.ControllerData.deselect_all_units()
