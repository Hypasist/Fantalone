extends Node

var display_manager_thread = null

func _init():
	display_manager_thread = Thread.new()
	
func execute_display_queues():
	while display_manager_thread.is_alive():
		yield(get_tree().create_timer(0.5), "timeout")
	var error = display_manager_thread.start(self, "execute_display_round")
	if error:
		Terminal.add_log(Debug.SYSTEM, Debug.ERROR, "Unable to create display queue thread: %d" % error)

var handled_objects_cnt = 0
func execute_display_round(_dummy):
	for tile in mod.MapView.get_tile_list():
		#objects_handled += 1
		#tile.execute_display_queue(self, "_display_queue_completed")
		pass
	for unit in mod.MapView.get_unit_list():
		if unit.has_commands_queued():
			handled_objects_cnt += 1
			unit.execute_display_queue(self, "_display_queue_completed")

func peek_display_queue():
	var queue_pop = 0
	for tile in mod.MapView.get_tile_list():
		#objects_handled += 1
		#tile.execute_display_queue(self, "_display_queue_completed")
		pass
	for unit in mod.MapView.get_unit_list():
		if unit.has_commands_queued():
			queue_pop += 1
	return queue_pop

func _display_queue_completed():
	handled_objects_cnt = max(0, handled_objects_cnt - 1)
	if handled_objects_cnt == 0:
		if peek_display_queue() > 0:
			yield(get_tree().create_timer(0.2), "timeout")
			execute_display_round(null)
		else:
			display_manager_thread.wait_to_finish()
