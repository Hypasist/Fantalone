class_name DisCmdGetPushedToEmpty
extends DisCmdBase

var current_position = Vector2(0,0)
var target_position = Vector2(0,0)

func _init(object_logic_).(object_logic_):
	incomplete_locks = 1

	current_position = object_display.position
	var target_coords = object_logic.hex.coords
	target_position = HexMath.hex_to_position(target_coords)

func execute():
	Terminal.add_log(Debug.ALL, Debug.DISPLAY_CMD, "[%s] DisCmdGetPushedToEmpty %s" % [object_logic.get_name_id(), object_logic.hex.coords.to_str()])
	
	var position_tween = CustomTween2.new()
	tween_list.append(position_tween)
	object_display.add_child(position_tween)
	position_tween.connect("tween_completed", self, "_release_lock")
	position_tween.initialize(object_display, "position", current_position, target_position, animation_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	position_tween.start_normal(current_position)
