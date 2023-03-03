class_name CommandData
extends Node

var Data = null

var expected_hash = null
var queue = []
func get_queue():
	return queue

func flush_queue():
	queue.clear()

func add_command(command_class, param_dictionary):
	if not LogCmd.command_dictionary.has(command_class):
		Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Unrecognized command in queue!")
		return
	param_dictionary["data"] = Data
	var new_command = command_class.new(param_dictionary)
	queue.append(new_command)

func new_command(command_class, param_dictionary):
	add_command(command_class, param_dictionary)
	execute_queue()

func verify_queue():
	var last_error = ErrorInfo.new()
	for command in queue:
		if not command.is_verified():  
			last_error = command.verify()
			if last_error.is_invalid():
				# THINK ABOUT WHETHER YOU WANT TO REMOVE INVALID COMMANDS HERE
				queue.erase(command)
				break
	return last_error

func execute_queue():
	if verify_queue().is_invalid():
		return verify_queue()
	for command in queue:
		if not command.is_done():  
			command.execute()
	mod.ControllerData.execute_display_commands()
	return ErrorInfo.new()

func is_executed():
	for command in queue:
		if not command.is_done():  
			return false
	return true

func unpack_command(param_dictionary):
	var command_class = LogCmd.unpack_command_name(param_dictionary["command_name"])
	add_command(command_class, param_dictionary)

func client_pack_queue():
	if mod.CommandData.is_executed():
		var packed_queue = QueueDataPackage.pack_queue(queue)
		mod.MatchNetwork.execute_command(MatchNetworkAPI.command.CLIENT_REQUEST_QUEUE, packed_queue)
		mod.CommandData.flush_queue()
	else:
		Terminal.add_log(Debug.ERROR, Debug.QUEUE_NETWORK, "client_queue not finished!")

func server_unpack_verify_and_execute_queue(packed_queue):
	flush_queue()
	QueueDataPackage.unpack_queue(packed_queue)
	if verify_queue().is_valid():
		execute_queue()
		QueueDataPackage.repack_queue(packed_queue)
		mod.MatchNetwork.execute_command(MatchNetworkAPI.command.SERVER_BROADCAST_QUEUE, packed_queue)
	else:
		var error_msg = verify_queue()
		var error_string = error_msg.get_invalid_string()
		mod.MatchNetwork.execute_command(MatchNetworkAPI.command.SERVER_DISCARD_QUEUE, error_string)

func client_unpack_and_execute_queue(packed_queue):
	if not mod.Network.is_server() && \
	   packed_queue[QueueDataPackage._QUEUE_INFO]["hash"] != MatchDataPackage.get_current_hash(mod):
		flush_queue()
		QueueDataPackage.unpack_queue(packed_queue)
		execute_queue()
	# CHECK HASH
