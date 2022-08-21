class_name DisCmdUntireUnit
extends DisCmdBase

func _init(unit_logic_).(unit_logic_):
	pass

func execute():
	Terminal.add_log(Debug.ALL, Debug.DISPLAY_CMD, "[%s] DisCmdUntireUnit %s" % [unit_logic.get_name_id(), unit_logic.hex.coords.to_str()])
	unit_display.set_tire(false)
	complete()
