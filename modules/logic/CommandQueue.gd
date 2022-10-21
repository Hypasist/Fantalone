class_name CommandQueue
extends Node

var expected_hash = null
var local_queue = []
var execution_queue = []
func get_local_queue():
	return local_queue
func get_execution_queue():
	return execution_queue

func flush_queue(queue):
	queue.clear()

func add_command(queue, command_class, param_dictionary):
	if not NetCmdInfo.command_dictionary.has(command_class):
		Terminal.add_log(Debug.ERROR, Debug.LOGIC_CMD, "Unrecognized command in queue!")
		return
	
	var new_command = command_class.new()
	new_command.setup(param_dictionary)
	queue.append(new_command)

func new_command(command_class, param_dictionary):
	add_command(local_queue, command_class, param_dictionary)

func unpack_command(param_dictionary):
	var command_class = NetCmdInfo.get_command_class(param_dictionary["command_name"])
	add_command(execution_queue, command_class, param_dictionary)

func verify_queue(queue):
	var last_error = ErrorInfo.new()
	for command in queue:
		if not command.get_state() == NetCmdBase.states.verified:  
			last_error = command.verify()
			if last_error.is_invalid():
				break
	return last_error

func report_to_server():
	# TODO omit if solo game
	if verify_queue(local_queue).is_valid():
		var packed_queue = QueueDataPackage.pack_queue(local_queue)
		mod.MatchNetwork.execute_command(MatchNetwork.command.TEST_REQUEST_COMMAND, packed_queue)
		flush_queue(local_queue)

func execute(queue):
	if verify_queue(queue).is_invalid():
		return verify_queue(queue)
	for command in queue:
		command.execute()
	return ErrorInfo.new()

func server_unpack_and_execute_queue(packed_queue):
	flush_queue(execution_queue)
	QueueDataPackage.unpack_queue(packed_queue)
	if verify_queue(execution_queue).is_valid():
		execute(execution_queue)
		QueueDataPackage.repack_queue(packed_queue)
		mod.MatchNetwork.execute_command(MatchNetwork.command.TEST_BROADCAST_COMMAND, packed_queue)
		# CALCULATE HASH
	else:
		var error_string = verify_queue(execution_queue).get_invalid_string()
		mod.MatchNetwork.execute_command(MatchNetwork.command.TEST_DISCARD_COMMAND, error_string)


func client_unpack_and_execute_queue(packed_queue):
	flush_queue(execution_queue)
	QueueDataPackage.unpack_queue(packed_queue)
	execute(execution_queue)
	# CHECK HASH
