extends Node

var display_manager_thread = null
func _init():
	display_manager_thread = Thread.new()
	
func execute_display_queues():
	print("start display_manager_thread")
	display_manager_thread.start(self, "execute_display_round")
	
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

func _display_queue_completed():
	handled_objects_cnt = max(0, handled_objects_cnt - 1)
	if handled_objects_cnt == 0:
		display_manager_thread.wait_to_finish()
