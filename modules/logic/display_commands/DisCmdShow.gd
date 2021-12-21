class_name DisCmdShow
extends DisCmdBase

func _init(unit_logic_).(unit_logic_):
	pass

func execute():
	Terminal.addLog(unit_logic.get_name_id() + " DisCmdShow " + unit_logic.hex.coords.to_str())
	
	unit_display.show()
	complete()
