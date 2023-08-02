class_name DisCmdBase
extends Node

var animation_time = 1
var incomplete_locks = 0
var tween_list = []
var object_logic = null
var object_display = null
signal command_completed()

func _init(object_logic_):
	# IF THERE IS NO OBJECT_DISPLAY -- IT'S LOGIC ONLY, ABORT
	if object_logic_.display == null:
		return
		
	object_logic = object_logic_
	object_display = object_logic.display
	object_logic.add_to_display_queue(self)

func execute():
	Terminal.add_log(Debug.ERROR, Debug.DISPLAY_CMD, "Trying to execute DisCmdBase!")

func complete():
	emit_signal("command_completed")

func abort():
	object_display.hide()

func _release_lock(_object = null, _key = null):
	incomplete_locks = max(0, incomplete_locks - 1)
	if incomplete_locks == 0:
		for tween in tween_list:
			tween.queue_free()
		complete()
