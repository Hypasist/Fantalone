class_name LogCmdFinishTurn
extends LogCmdBase

var turn_owner = null
var actions_left = 0

func _init(param_dictionary).(param_dictionary):
	turn_owner = param_dictionary["caller"]
	actions_left = param_dictionary["actions_left"]
	action_cost = 0
	mana_cost = 0


func verify():
	if .verify().is_invalid(): return .verify()
	if turn_owner != mod.MatchLogic.get_turn_owner():
		return ErrorInfo.new(ErrorInfo.invalid.not_your_turn)
	elif mod.MatchLogic.get_action_counter() == 0:
		return ErrorInfo.new(ErrorInfo.invalid.need_at_least_one_move)
	else:
		set_state(states.verified)
		return ErrorInfo.new()

func execute():
	.execute()
	mod.MatchLogic.new_turn()
	set_state(states.done)


func pack_command():
	var pack = {}
	pack["command_name"] = "LogCmdFinishTurn"
	pack["caller"] = caller
	pack["actions_left"] = actions_left
	return pack

static func unpack_command(pack):
	pass
