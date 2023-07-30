extends Button

func _ready():
	pass # Replace with function body.

func update():
	set_visible(mod.ControllerData.any_command_issued())
	#set_disabled(not mod.ControllerData.any_command_issued())

func _on_RestoreTurn_pressed():
	mod.ControllerData.restore_match_status()
