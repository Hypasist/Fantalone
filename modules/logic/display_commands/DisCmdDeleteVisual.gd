class_name DisCmdDeleteVisual
extends DisCmdBase

func _init(unit_logic_).(unit_logic_):
	pass

func execute():
	if debug_verbose_display_commands:
		Terminal.add_log(Debug.ALL, "[%s] DisCmdDeleteVisual %s" % [unit_logic.get_name_id(), unit_logic.hex.coords.to_str()])
	
	unit_display.queue_free()
	complete()
