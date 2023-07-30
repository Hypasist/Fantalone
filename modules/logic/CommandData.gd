class_name CommandData
extends Node

var Data = null

var expected_hash = null
var queue = []
func get_queue():
	return queue
func any_command_issued():
	return not queue.empty()

func setup():
	flush_queue()
	
func flush_queue():
	queue.clear()

func add_command(command_class, param_dictionary):
	if not LogCmd.command_dictionary.has(command_class):
		Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Unrecognized command in queue!")
		return
	param_dictionary["data"] = Data
	var new_command = command_class.new(param_dictionary)
	Terminal.add_log(Debug.INFO, Debug.LOGIC_CMD, "Command [%s] added!" % new_command.name)
	queue.append(new_command)

# This is temporal solution for spells only - we are adding already existing instance
func add_existing_command(existing_command):
	existing_command.Data = Data
	Terminal.add_log(Debug.INFO, Debug.LOGIC_CMD, "Existing command [%s] added!" % existing_command.name)
	queue.append(existing_command)
	execute_queue()

func new_command(command_class, param_dictionary):
	add_command(command_class, param_dictionary)
	execute_queue()

func execute_queue():
	var last_error = ErrorInfo.new()
	for command in queue:
		if not command.is_done():  
			if not command.is_verified():
				last_error = command.verify()
				if last_error.is_invalid():
					Terminal.add_log(Debug.ERROR, Debug.QUEUE_NETWORK, \
						"Invalid command - %s." % [last_error.get_invalid_string()])
					queue.erase(command)
					return last_error
			command.execute()
			Terminal.add_log(Debug.INFO, Debug.LOGIC_CMD, "Command [%s] executed!" % command.name)
	mod.ControllerData.update_display()
	return ErrorInfo.new()

func is_executed():
	for command in queue:
		if not command.is_done():  
			return false
	return true

func client_pack_and_send_queue():
	if is_executed():
		mod.MatchNetworkAPI.send_to_server(MatchNetworkAPI.command.CLIENT_REQUEST_QUEUE, \
											QueueDataPackage.pack_queue(Data))
		flush_queue()
	else:
		Terminal.add_log(Debug.ERROR, Debug.QUEUE_NETWORK, "client_queue not finished!")

func server_unpack_verify_and_execute_queue(packed_queue):
	var client_network_id = packed_queue[QueueDataPackage._QUEUE_INFO]["sender"]
	
	# verify if turn counter and hash is correct
	if QueueDataPackage.verify_pack(Data, packed_queue):
		save_match_status()
		QueueDataPackage.unpack_queue(Data, packed_queue)
		var error = execute_queue()
		if error.is_valid():
			Data.MatchData.server_endturn_routine()
			packed_queue = QueueDataPackage.repack_queue(Data)
			mod.MatchNetworkAPI.broadcast_to_clients(MatchNetworkAPI.command.SERVER_BROADCAST_QUEUE, packed_queue)
		else:
			var error_string = error.get_invalid_string()
			mod.MatchNetworkAPI.send_to_client(MatchNetworkAPI.command.SERVER_DISCARD_QUEUE, client_network_id, error_string)
			Terminal.add_log(Debug.ERROR, Debug.QUEUE_NETWORK, "%s - Restoring match status" % [error_string])
			restore_match_status()
		flush_queue()			
	
	else:
		Terminal.add_log(Debug.INFO, Debug.QUEUE_NETWORK, \
			"Discarded package from %d." % [packed_queue[QueueDataPackage._QUEUE_INFO]["sender"]])
		mod.MatchNetworkAPI.send_to_client(MatchNetworkAPI.command.SERVER_DISCARD_QUEUE, \
			client_network_id, ErrorInfo.new(ErrorInfo.invalid.invalid_turn_counter))

func client_unpack_and_execute_queue(packed_queue):
	# verify if turn counter and hash is correct
	if QueueDataPackage.verify_pack(Data, packed_queue):
		save_match_status()
		QueueDataPackage.unpack_queue(Data, packed_queue)
		var error = execute_queue()
		if error.is_valid() and \
			packed_queue[QueueDataPackage._QUEUE_INFO]["hash"] == MatchDataPackage.get_current_hash(Data):
			pass
		else:
			var error_string = error.get_invalid_string()
			Terminal.add_log(Debug.ERROR, Debug.QUEUE_NETWORK, "%s - Restoring match status" % [error_string])
			restore_match_status()
			mod.MatchNetworkAPI.send_to_server(MatchNetworkAPI.command.CLIENT_REQUEST_MATCH_STATUS)
		flush_queue()
	
	else:
		Terminal.add_log(Debug.INFO, Debug.QUEUE_NETWORK, \
			"Discarded package from %d." % [packed_queue[QueueDataPackage._QUEUE_INFO]["sender"]])

## MATCH STATE SAVE / LOAD
var saved_match_status = null
func save_match_status():
	saved_match_status = MatchDataPackage.pack_match(Data)
func restore_match_status():
	mod.ControllerData.deselect_all_units()
	Data.MatchData.setup(saved_match_status)
	flush_queue()
	mod.ControllerData.update_display()

# debug
func print_current_command_queue():
	for command in get_queue():
		print("%s - %s" % [command.get_command_name(), command.get_state_name()])
func print_packaged_command_queue(package):
	for record in package[QueueDataPackage._QUEUE_COMMANDS]:
		print(" - %s" % [record["command_name"]])
