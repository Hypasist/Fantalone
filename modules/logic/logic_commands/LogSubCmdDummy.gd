class_name LogSubCmdDummy
extends LogSubCmdBase

func _init(param_dictionary).(param_dictionary):
	pass

func verify():
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to verify LogSubCmdDummy class!")

func execute():
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to execute LogSubCmdDummy class!")

func pack_command():
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to pack_command LogSubCmdDummy class!")

static func unpack_command(pack):
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to unpack_command LogSubCmdDummy class!")
