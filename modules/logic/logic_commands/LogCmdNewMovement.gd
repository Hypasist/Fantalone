class_name LogCmdNewMovement
extends LogCmdBase

var units = null
var direction = null

func _init(param_dictionary).(param_dictionary):
	units = param_dictionary.units
	direction = param_dictionary.direction
	action_cost = 1

func verify():
	if .verify().is_invalid(): return .verify()
	var movement = mod.MatchLogic.verify_movement(units, direction)
	if not movement.is_valid():
		return movement.get_error_info()
	else:
		return ErrorInfo.new()

func execute():
	var movement = mod.MatchLogic.execute_movement(units, direction)
	.execute()
	set_state(states.done)

func pack_command():
	var pack = {}
	pack["command_name"] = get_class()
	pack["caller"] = caller
	pack["units"] = units
	pack["direction"] = direction
	return pack

func unpack_command(record):
#	setup(record)
	pass