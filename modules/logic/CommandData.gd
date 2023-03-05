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
	mod.ControllerData.update_display()

func execute_queue():
	var last_error = ErrorInfo.new()
	for command in queue:
		if not command.is_done():  
			if not command.is_verified():
				last_error = command.verify()
				if last_error.is_invalid():
					return last_error
			command.execute()
	return ErrorInfo.new()

func is_executed():
	for command in queue:
		if not command.is_done():  
			return false
	return true

func client_pack_queue():
	if is_executed():
		mod.MatchNetworkAPI.send_to_server(MatchNetworkAPI.command.CLIENT_REQUEST_QUEUE, \
											QueueDataPackage.pack_queue(Data))
		flush_queue()
	else:
		Terminal.add_log(Debug.ERROR, Debug.QUEUE_NETWORK, "client_queue not finished!")

func server_unpack_verify_and_execute_queue(packed_queue):
	var client_network_id = packed_queue[QueueDataPackage._QUEUE_INFO]["sender"]
	Data.MatchData.save_match_status()
	flush_queue()
	QueueDataPackage.unpack_queue(Data, packed_queue)
	var error = execute_queue().is_valid()
	if error.is_valid():
		QueueDataPackage.repack_queue(Data, packed_queue)
		mod.MatchNetworkAPI.broadcast_to_clients(MatchNetworkAPI.command.SERVER_BROADCAST_QUEUE, packed_queue)
		mod.MatchNetworkAPI.send_to_client(MatchNetworkAPI.command.SERVER_ACCEPT_QUEUE, client_network_id)
	else:
		var error_string = error.get_invalid_string()
		mod.MatchNetworkAPI.send_to_client(MatchNetworkAPI.command.SERVER_DISCARD_QUEUE, client_network_id, error_string)
		Data.MatchData.save_match_status()

func client_unpack_and_execute_queue(packed_queue):
	flush_queue()
	QueueDataPackage.unpack_queue(Data, packed_queue)
	execute_queue()
#	if packed_queue[QueueDataPackage._QUEUE_INFO]["hash"] != MatchDataPackage.get_current_hash(mod):
#		flush_queue()
#		QueueDataPackage.unpack_queue(Data, packed_queue)
#		execute_queue()
