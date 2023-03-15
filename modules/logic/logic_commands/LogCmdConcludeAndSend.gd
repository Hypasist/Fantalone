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
	Data.MatchData.increase_turn_counter()
	set_state(states.done)
	if mod.NetworkData.is_multiplayer_game():
		Data.CommandData.client_pack_and_send_queue()
	else: # SINGLEPLAYER GAME
		pass

func pack_command():
	var pack = {}
	pack["command_name"] = "LogCmdConclude"
	return pack

static func unpack_command(Data, pack):
	return pack
