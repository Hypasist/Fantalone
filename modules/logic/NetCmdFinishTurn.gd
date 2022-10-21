class_name NetCmdFinishTurn
extends NetCmdBase

var turn_owner = null
var actions_left = 0

func _init().():
	action_cost = 0
	mana_cost = 0

func setup(param_dictionary):
	.setup(param_dictionary)
	turn_owner = param_dictionary["caller"]
	actions_left = param_dictionary["actions_left"]


func verify():
	if turn_owner != mod.MatchLogic.get_turn_owner():
		return ErrorInfo.new(ErrorInfo.invalid.not_your_turn)
	elif mod.MatchLogic.get_action_counter() == 0:
		return ErrorInfo.new(ErrorInfo.invalid.need_at_least_one_move)
	else:
		set_state(NetCmdBase.states.verified)
		return ErrorInfo.new()

func execute():
	var error_info = verify()
	if error_info.is_valid():
		mod.MatchLogic.new_turn()
	else:
		#rpc_id(network_id, "match_network_execute_command", command.DISCARD_MOVE, movement.invalid_reason)
		pass

func get_command_name():
	return "NetCmdFinishTurn"

func pack_command():
	var pack = {}
	pack["command_name"] = get_command_name()
	pack["caller"] = caller
	pack["actions_left"] = actions_left
	return pack

func unpack_command(record):
	setup(record)
