class_name QueueDataPackage

enum { _QUEUE_COMMANDS, _QUEUE_INFO }

static func pack_queue(queue):
	var package = {}
	
	package[_QUEUE_COMMANDS] = []
	for command in queue:
		package[_QUEUE_COMMANDS].append(command.pack_command())
	return package

static func repack_queue(package):
	package[_QUEUE_INFO] = {}
	# package[_QUEUE_INFO]["queue_counter"] = mod.Network.get_communication_counter()
	package[_QUEUE_INFO]["hash"] = MatchDataPackage.get_current_hash()

static func unpack_queue(package):
	for param_dictionary in package[_QUEUE_COMMANDS]:
		var command_class = LogCmd.unpack_command_name(param_dictionary["command_name"])
		if param_dictionary.has("units"):
			print(param_dictionary["units"])
		command_class.unpack_command(param_dictionary)
		if param_dictionary.has("units"):
			print(param_dictionary["units"])
		mod.CommandQueue.add_server_command(command_class, param_dictionary)
