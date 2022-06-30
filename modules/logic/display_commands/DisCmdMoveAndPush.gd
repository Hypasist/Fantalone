class_name DisCmdMoveAndPush
extends DisCmdBase

var current_position = Vector2(0,0)
var target_position = Vector2(0,0)

func _init(unit_logic_).(unit_logic_):
	incomplete_locks = 1

	current_position = unit_display.position
	var target_coords = unit_logic.hex.coords
	target_position = mod.Logic.hex_to_position(target_coords)

func execute():
	if debug_verbose_display_commands:
		Terminal.add_log(Debug.ALL, Debug.DISPLAY_CMD, "[%s] DisCmdMoveAndPush %s" % [unit_logic.get_name_id(), unit_logic.hex.coords.to_str()])
	
	var position_tween = CustomTween2.new()
	tween_list.append(position_tween)
	unit_display.add_child(position_tween)
	position_tween.connect("tween_completed", self, "_release_lock")
	position_tween.initialize(unit_display, "position", current_position, target_position, animation_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	position_tween.start_normal(current_position)
