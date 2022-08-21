class_name DisCmdGetDrown
extends DisCmdBase

func _init(object_logic_).(object_logic_):
	incomplete_locks = 1

func execute():
	Terminal.add_log(Debug.ALL, Debug.DISPLAY_CMD, "[%s] DisCmdGetDrown %s" % [object_logic.get_name_id(), object_logic.hex.coords.to_str()])
	object_display.start_animation(UnitAnimations.drowning, UnitAnimations.type.one_shot, \
								 self, "_release_lock")
