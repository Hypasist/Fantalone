class_name LogCmdMoveToEmpty
extends LogCmdBase

var unit = null
var destination_hex = null

func _init(unit_, destination_hex_).(unit_):
	unit = unit_
	destination_hex = destination_hex_

func execute():
	unit.move_to_hex(destination_hex)
	var display_command = DisCmdMoveToEmpty.new(unit)
	unit.add_to_display_queue(display_command)
