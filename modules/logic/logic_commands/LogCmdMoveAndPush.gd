class_name LogCmdMoveAndPush
extends LogCmdBase

var unit = null
var destination_hex = null

func _init(unit_, destination_hex_).(unit_):
	unit = unit_
	destination_hex = destination_hex_
	if debug_verbose_base_commands:
		Terminal.add_log(Debug.ALL, "[%s] New LogCmdMoveAndPush from %s to %s" % [unit.get_name_id(), unit.hex.coords.to_str(), destination_hex.coords.to_str()])

func execute():
	if debug_verbose_base_commands:
		Terminal.add_log(Debug.ALL, "[%s] LogCmdMoveAndPush %s" % [unit.get_name_id(), unit.hex.coords.to_str()])
	
	unit.move_to_hex(destination_hex)
	var display_command = DisCmdMoveToEmpty.new(unit)
	unit.add_to_display_queue(display_command)

	unit.tire()
	display_command = DisCmdUpdateTiredState.new(unit)
	unit.add_to_display_queue(display_command)
