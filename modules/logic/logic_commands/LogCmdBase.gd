class_name LogCmdBase
extends Reference

export(int,"off","on") var debug_verbose_base_commands = 1
var subject = null

func _init(subject_):
	subject = subject_

func execute():
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to execute LogCmdBase class!")
