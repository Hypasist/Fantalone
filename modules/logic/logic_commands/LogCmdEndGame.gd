class_name LogCmdEndGame
extends LogCmdBase

var winner = null

func _init(param_dictionary).(param_dictionary):
	winner = param_dictionary["winner"]

func verify():
	set_state(states.verified)
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
