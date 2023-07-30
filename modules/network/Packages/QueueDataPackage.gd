class_name QueueDataPackage

enum { _QUEUE_COMMANDS, _QUEUE_INFO }

static func pack_queue(Data):
	var package = {}
	
	package[_QUEUE_COMMANDS] = []
	for command in Data.CommandData.get_queue():
		package[_QUEUE_COMMANDS].append(command.pack_command())

	package[_QUEUE_INFO] = {}
	package[_QUEUE_INFO]["queue_counter"] = Data.MatchData.get_turn_counter()
	package[_QUEUE_INFO]["hash"] = MatchDataPackage.get_current_hash(Data)
	package[_QUEUE_INFO]["sender"] = mod.NetworkData.get_id()
	return package

static func repack_queue(Data):
	var package = pack_queue(Data)
	package[_QUEUE_INFO] = {}
	package[_QUEUE_INFO]["queue_counter"] = Data.MatchData.get_turn_counter()
	package[_QUEUE_INFO]["hash"] = MatchDataPackage.get_current_hash(Data)
	package[_QUEUE_INFO]["sender"] = mod.NetworkData.get_id()
	return package

static func unpack_queue(Data, package):
	Data.CommandData.flush_queue()
	for record in package[_QUEUE_COMMANDS]:
		var command_class = LogCmd.unpack_command_name(record["command_name"])
		command_class.unpack_command(Data, record)
		Data.CommandData.add_command(command_class, record)

static func verify_pack(Data, package):
	# consecutive turn_counter, accept
	if ((Data.MatchData.get_turn_counter() + 1) == \
		package[_QUEUE_INFO]["queue_counter"]):
		return true
	# already has this package, discard
	elif ((Data.MatchData.get_turn_counter()) == \
		package[_QUEUE_INFO]["queue_counter"]) and \
		(MatchDataPackage.get_current_hash(Data) == \
		package[_QUEUE_INFO]["hash"]):
		Terminal.add_log(Debug.INFO, Debug.QUEUE_NETWORK, \
			"Package already assimilated (TC: %d | H: %d)." % \
			[package[_QUEUE_INFO]["queue_counter"], \
			package[_QUEUE_INFO]["hash"]])
		return false
	# incorrect package, report an error
	else:
		Terminal.add_log(Debug.ERROR, Debug.QUEUE_NETWORK, \
			"Invalid package from %s (TC: %d != %d | H: %d != %d)." % \
			[package[_QUEUE_INFO]["sender"], \
			Data.MatchData.get_turn_counter() + 1, \
			package[_QUEUE_INFO]["queue_counter"], \
			MatchDataPackage.get_current_hash(Data), \
			package[_QUEUE_INFO]["hash"]])
		return false
