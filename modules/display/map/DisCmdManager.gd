extends Node

var display_manager_thread = null

func _init():
	display_manager_thread = Thread.new()

func execute_display_queues():
	while display_manager_thread.is_alive() or display_manager_thread.is_active():
		yield(get_tree().create_timer(0.5), "timeout")
	var error = display_manager_thread.start(self, "kick_display_thread")
	if error:
		Terminal.add_log(Debug.SYSTEM, Debug.ERROR, "Unable to create display queue thread: %d" % error)

func kick_display_thread(_dummy):
	execute_display_round()

var object_busy_list = []
func execute_display_round():
	var kicked_objects = 0
	for tile in mod.MapView.get_tile_list():
		#objects_handled += 1
		#tile.execute_display_queue(self, "_display_queue_completed")
		pass
	for unit in mod.MapView.get_unit_list():
		if unit.has_commands_queued() && not object_busy_list.has(unit):
			kicked_objects += 1
			object_busy_list.append(unit)
			unit.execute_display_queue(self, "_display_queue_completed")
	if kicked_objects == 0:
		display_manager_thread.wait_to_finish()

func _display_queue_completed(object):
	object_busy_list.erase(object)
	if object_busy_list.empty():
		execute_display_round()
