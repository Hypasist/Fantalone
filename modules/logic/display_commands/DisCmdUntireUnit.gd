class_name DisCmdUntireUnit
extends DisCmdBase

func _init(object_logic_).(object_logic_):
	pass

func execute():
	Terminal.add_log(Debug.ALL, Debug.DISPLAY_CMD, "[%s] DisCmdUntireUnit %s" % [object_logic.get_name_id(), object_logic.hex.coords.to_str()])
	object_display.set_tire(false)
	complete()