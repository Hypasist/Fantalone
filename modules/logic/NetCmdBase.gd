class_name NetCmdBase

const SERVER_CALL = -1
var caller = null
var action_cost = 0
var mana_cost = 0

enum states { new, pending, verified, done }
var state = null

func _init():
	set_state(states.new)

func set_state(_state):
	state = _state
func get_state():
	return state

func get_command_name():
	return null

func pack_command():
	pass

func unpack_command(_record):
	pass

func setup(param_dictionary):
	caller = param_dictionary["caller"]

func verify():
	return ErrorInfo.new()

func execute():
	pass

