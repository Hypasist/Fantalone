class_name DisCmdMoveToEmpty
extends DisCmdBase

func _init(unit_logic_).(unit_logic_):
	animation_time = 1.2
	target_tween_locks = 1

func execute():
	position_tween = CustomTween2.new()
	unit_display.add_child(position_tween)
	position_tween.connect("tween_completed", self, "_position_tween_completed")
	
	var current_position = unit_display.position
	var target_coords = unit_logic.hex.coords
	var target_position = mod.Logic.hex_to_position(target_coords)
	
	position_tween.initialize(unit_display, "position", current_position, target_position, animation_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	position_tween.start_normal(current_position)


var position_tween = null
func _position_tween_completed():
	completed_tween_locks += 1
	complete_command()
	
func complete_command():
	if completed_tween_locks == target_tween_locks:
		position_tween.free()
		#unit_display.command_completed()
