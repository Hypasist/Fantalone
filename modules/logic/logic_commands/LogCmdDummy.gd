class_name LogCmdDummy
extends LogCmdBase

func _init(param_dictionary).(param_dictionary):
	pass

func verify():
	return ErrorInfo.new()

func execute():
	pass

func pack_command():
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to pack_command LogCmdDummy class!")

static func unpack_command(Data, pack):
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to unpack_command LogCmdDummy class!")
	return pack
