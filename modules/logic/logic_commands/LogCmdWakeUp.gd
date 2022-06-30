class_name LogCmdWakeUp
extends LogCmdBase

var unit = null

func _init(unit_).(unit_):
	unit = unit_
	if debug_verbose_base_commands:
		Terminal.add_log(Debug.ALL, Debug.LOGIC_CMD, "[%s] New LogCmdWakeUp on %s" % [unit.get_name_id(), unit.hex.coords.to_str()])

func execute():
	if debug_verbose_base_commands:
		Terminal.add_log(Debug.ALL, Debug.LOGIC_CMD, "[%s] LogCmdWakeUp %s" % [unit.get_name_id(), unit.hex.coords.to_str()])
	
	unit.untire()
	var display_command = DisCmdUpdateTiredState.new(unit)
	unit.add_to_display_queue(display_command)
