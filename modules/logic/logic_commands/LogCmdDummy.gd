class_name LogCmdDummy
extends LogCmdBase

func _init(subject_).(subject_):
	pass

func execute():
	Terminal.add_log(Debug.ERROR, "Trying to execute LogCmdDummy class!")
