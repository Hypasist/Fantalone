class_name LogCmdSpellBase
extends LogCmdBase

var image_path = ""
var cooldown = 0
var selection_limit = 0

func _init(param_dictionary).(param_dictionary):
	pass

func new_selected(object):
	print(object.get_name_id())

func clear_selection():
	pass

func cast():
	pass

#func verify():
#	set_state(states.verified)
#	return ErrorInfo.new()

func execute():
	.execute()
	set_state(states.done)

func pack_command():
	var pack = {}
	pack["command_name"] = "LogCmdSpellcast"
	return pack

static func unpack_command(Data, pack):
	return pack
