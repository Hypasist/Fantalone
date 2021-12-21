class_name DisCmdBase
extends Node

var animation_time = 1
var incomplete_locks = 0
var tween_list = []
var unit_logic = null
var unit_display = null
signal command_completed()

func _init(unit_logic_):
	unit_logic = unit_logic_
	unit_display = unit_logic_.unitDisplay

func execute():
	Terminal.addLog("ERROR, trying to execute DisCmdBase!")

func complete():
	emit_signal("command_completed")

func _release_lock(_object = null, _key = null):
	incomplete_locks = max(0, incomplete_locks - 1)
	if incomplete_locks == 0:
		for tween in tween_list:
			tween.queue_free()
		complete()
