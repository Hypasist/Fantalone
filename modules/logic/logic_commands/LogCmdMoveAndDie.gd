class_name LogCmdMoveAndDie
extends LogCmdBase

var unit = null
var destination_hex = null

func _init(unit_, destination_hex_).(unit_):
	unit = unit_
	destination_hex = destination_hex_
	Terminal.addLog(unit.get_name_id() + " new LogCmdMoveAndDie from " + unit.hex.coords.to_str() + " to " + destination_hex.coords.to_str())

func execute():
	Terminal.addLog(unit.get_name_id() + " LogCmdMoveAndDie " + unit.hex.coords.to_str())

	unit.move_to_hex(destination_hex)
	var display_command = DisCmdMoveToDeath.new(unit)
	unit.add_to_display_queue(display_command)
	
	unit.die()
	display_command = DisCmdGetDrown.new(unit)
	unit.add_to_display_queue(display_command)

	display_command = DisCmdHide.new(unit)
	unit.add_to_display_queue(display_command)
