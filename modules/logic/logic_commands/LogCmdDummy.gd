class_name LogCmdDummy
extends LogCmdBase

func _init(_subject).(null, _subject):
	pass

func execute():
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to execute LogCmdDummy class!")
