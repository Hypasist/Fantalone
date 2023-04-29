class_name LogCmdEndGame
extends LogCmdBase

var winner = null

func _init(param_dictionary).(param_dictionary):
	winner = param_dictionary["winner"]

func verify():
	if .verify().is_invalid(): return .verify()

	var player_count = Data.MatchPlayerInfo_dict.size()
	
#	if turn_owner != Data.MatchData.get_turn_owner():
#		return ErrorInfo.new(ErrorInfo.invalid.not_your_turn)
#	elif Data.MatchData.get_action_counter() == 0:
#		return ErrorInfo.new(ErrorInfo.invalid.need_at_least_one_move)
#	else:
#		set_state(states.verified)
	return ErrorInfo.new()

func execute():
	.execute()
	print("EXECUTE ENDGAME OMEGALUL")
	set_state(states.done)


func pack_command():
	var pack = {}
	pack["command_name"] = "LogCmdEndGame"
	pack["caller"] = caller
	pack["winner"] = winner
	return pack

static func unpack_command(Data, pack):
	return pack
