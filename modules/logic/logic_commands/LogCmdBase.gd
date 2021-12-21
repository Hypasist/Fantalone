class_name LogCmdBase
extends Reference

var subject = null

func _init(subject_):
	subject = subject_

func execute():
	Terminal.addLog("ERROR, trying to execute LogCmdBase class!")
