class_name DisCmdBase
extends Reference

var animation_time = 1
var target_tween_locks = 0
var completed_tween_locks = 0
var unit_logic = null
var unit_display = null

func _init(unit_logic_):
	unit_logic = unit_logic_
	unit_display = unit_logic_.unitDisplay

func execute():
	Terminal.addLog("ERROR, trying to execute DisCmdBase class!")