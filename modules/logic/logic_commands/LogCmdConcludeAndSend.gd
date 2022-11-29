class_name LogCmdConcludeAndSend
extends LogCmdBase

var turn_owner = null
var actions_left = 0

func _init(param_dictionary).(param_dictionary):
	action_cost = 0
	mana_cost = 0

func verify():
	set_state(states.verified)
	return ErrorInfo.new()

func execute():
	set_state(states.done)
	if mod.Network.is_multidevice_game():
		if mod.Network.is_server():
			pass
		else:
			mod.CommandQueue.client_pack_queue()

func pack_command():
	var pack = {}
	pack["command_name"] = "LogCmdDummy"
	return pack

func unpack_command(record):
	pass
