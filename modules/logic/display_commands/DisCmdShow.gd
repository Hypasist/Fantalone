class_name DisCmdShow
extends DisCmdBase

func _init(object_logic_).(object_logic_):
	if object_display == null:
		return

func execute():
	Terminal.add_log(Debug.ALL, Debug.DISPLAY_CMD, "[%s] DisCmdShow %s" % [object_logic.get_name_id(), object_logic.hex.coords.to_str()])
	object_display.show()
	complete()
