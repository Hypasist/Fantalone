class_name CommandQueue
extends Node

var expected_hash = null
var local_queue = []
var server_queue = []
func get_local_queue():
	return local_queue
func get_server_queue():
	return server_queue

func flush_queue(queue):
	queue.clear()
func flush_local_queue():
	flush_queue(local_queue)

func add_server_command(command_class, param_dictionary):
	add_command(server_queue, command_class, param_dictionary)

func add_command(queue, command_class, param_dictionary):
	if not LogCmd.command_dictionary.has(command_class):
		Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Unrecognized command in queue!")
		return
	
	var new_command = command_class.new(param_dictionary)
	queue.append(new_command)

func new_command(command_class, param_dictionary):
	add_command(local_queue, command_class, param_dictionary)
	execute(local_queue)


func verify_queue(queue):
	var last_error = ErrorInfo.new()
	for command in queue:
		if not command.is_verified():  
			last_error = command.verify()
			if last_error.is_invalid():
				print(last_error.get_invalid_string())
				# THINK ABOUT WHETHER YOU WANT TO REMOVE INVALID COMMANDS HERE
				queue.erase(command)
				break
	return last_error

func execute(queue):
	if verify_queue(queue).is_invalid():
		return verify_queue(queue)
	for command in queue:
		if not command.is_done():  
			command.execute()
	mod.MapView.execute_display_queues()
	return ErrorInfo.new()

func is_executed(queue):
	for command in queue:
		if not command.is_done():  
			return false
	return true
func is_local_queue_executed():
	return is_executed(local_queue)
func is_server_queue_executed():
	return is_executed(server_queue)

func client_pack_queue():
	if mod.CommandQueue.is_local_queue_executed():
		var packed_queue = QueueDataPackage.pack_queue(local_queue)
		mod.MatchNetwork.execute_command(MatchNetwork.command.CLIENT_REQUEST_QUEUE, packed_queue)
		mod.CommandQueue.flush_local_queue()
	else:
		Terminal.add_log(Debug.ERROR, Debug.QUEUE_NETWORK, "client_queue not finished!")

func server_unpack_and_execute_queue(packed_queue):
	flush_queue(server_queue)
	QueueDataPackage.unpack_queue(packed_queue)
	if verify_queue(server_queue).is_valid():
		execute(server_queue)
		QueueDataPackage.repack_queue(packed_queue)
		mod.MatchNetwork.execute_command(MatchNetwork.command.SERVER_BROADCAST_QUEUE, packed_queue)
	else:
		var error_msg = verify_queue(server_queue)
		var error_string = error_msg.get_invalid_string()
		mod.MatchNetwork.execute_command(MatchNetwork.command.SERVER_DISCARD_QUEUE, error_string)

func client_unpack_and_execute_queue(packed_queue):
	if not mod.Network.is_server() && \
	   packed_queue[QueueDataPackage._QUEUE_INFO]["hash"] != MatchDataPackage.get_current_hash():
		flush_queue(server_queue)
		QueueDataPackage.unpack_queue(packed_queue)
		execute(server_queue)
	# CHECK HASH
