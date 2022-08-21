class_name LogCmdBase
extends Reference

var caster = null
var subject = null

func _init(_caster, _subject):
	caster = _caster
	subject = _subject

func execute():
	Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Trying to execute LogCmdBase class!")
