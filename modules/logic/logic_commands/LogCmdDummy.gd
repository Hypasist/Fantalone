class_name LogSubCmdDummy
extends LogSubCmdBase

func _init(param_dictionary).(param_dictionary):
	pass

func verify():
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to verify LogCmdDummy class!")

func execute():
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to execute LogCmdDummy class!")

func pack_command():
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to pack_command LogCmdDummy class!")

func unpack_command(record):
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to unpack_command LogCmdDummy class!")
