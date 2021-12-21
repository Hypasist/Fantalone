class_name DisCmdGetDrown
extends DisCmdBase

func _init(unit_logic_).(unit_logic_):
	incomplete_locks = 1

func execute():
	Terminal.addLog(unit_logic.get_name_id() + " DisCmdGetDrown " + unit_logic.hex.coords.to_str())
	
	unit_display.start_animation(UnitAnimations.drowning, UnitAnimations.type.one_shot, \
								 self, "_release_lock")
