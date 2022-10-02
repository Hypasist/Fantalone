extends Node

var display_manager_thread = null
var display_kick_mutex = null

func _init():
	display_manager_thread = Thread.new()
	display_kick_mutex = Mutex.new()

func execute_display_queues():
	if display_manager_thread.is_alive() or display_manager_thread.is_active():
		kick_display_queues()
	else:
		var error = display_manager_thread.start(self, "start_display_thread")
		if error:
			Terminal.add_log(Debug.SYSTEM, Debug.ERROR, "Unable to create display queue thread: %d" % error)

func start_display_thread(_dummy):
	kick_display_queues()

var object_busy_counter = 0
func kick_display_queues():
	display_kick_mutex.lock()
	if object_busy_counter == 0:
		for tile in mod.MapView.get_display_tile_list():
			#objects_handled += 1
			#tile.execute_display_queue(self, "_display_queue_completed")
			pass
		for unit in mod.MapView.get_display_unit_list():
			if unit.has_commands_queued() && not unit.is_display_busy():
				object_busy_counter += 1
				unit.execute_display_queue(self, "_display_queue_completed")
	display_kick_mutex.unlock()

func _display_queue_completed():
	display_kick_mutex.lock()
	object_busy_counter -= 1
	display_kick_mutex.unlock()
	kick_display_queues()
