class_name MatchNetworkAPI
extends Node

enum command { \
	UPDATE_MATCH_STATUS, \
	START_MATCH, \
	\
	\
	\
	UPDATE_TURN_OWNER, \
	VERIFY_MOVE, \
	BROADCAST_MOVELIST, \
	DISCARD_MOVE, \
	REQUEST_MOVE, \
	EXECUTE_MOVE, \
	EXECUTE_MOVELIST, \
	BROADCAST_COMMAND_LIST, \
	BROADCAST_MATCH_HASH_STATUS_REQUEST, \
	REQUEST_MATCH_HASH_STATUS, \
	SEND_MATCH_HASH_STATUS, \
	
	TEST_SEND_MATCH_STATE_HASH, \
	TEST_VERIFY_MATCH_STATE_HASH, \
	
	SERVER_CHECK_MATCH_SYNC, \
	CLIENT_VERIFY_MATCH_SYNC, \
	SERVER_SYNC_MATCH_STATUS, \
	SERVER_BROADCAST_MATCH_STATUS, \
	CLIENT_CONFIRM_SYNC, \
	
	CLIENT_REQUEST_QUEUE, \
	SERVER_BROADCAST_QUEUE, \
	SERVER_ACCEPT_QUEUE, \
	SERVER_DISCARD_QUEUE, \
}

const server_commands = [ \
	command.CLIENT_REQUEST_QUEUE, \
]
static func is_server_command(cmd):
	return server_commands.has(cmd)


const broadcast_commands = [ \
	command.UPDATE_MATCH_STATUS, \
	command.START_MATCH, \
]

static func is_broadcast_command(cmd):
	return broadcast_commands.has(cmd)


func setup():
	rpc_config("match_network_execute_command", MultiplayerAPI.RPC_MODE_SYNC)


func send_to_server(command, param1=null, param2=null, param3=null, param4=null):
	if is_broadcast_command(command) or not is_server_command(command):
		Terminal.add_log(Debug.ERROR, Debug.MATCH_NETWORK, "Trying to send unproper command to server! (%d)" % command)
		return
	
	if NetworkAPI.is_host():
		match_network_execute_command(command, param1, param2, param3, param4)
	else:
		rpc_id(NetworkAPI.SERVER_ID, "match_network_execute_command", command, param1, param2, param3, param4)

func broadcast_to_clients(command, param1=null, param2=null, param3=null, param4=null):
	if not is_broadcast_command(command) or is_server_command(command):
		Terminal.add_log(Debug.ERROR, Debug.MATCH_NETWORK, "Trying to broadcast unproper command!")
		return
	
	rpc("match_network_execute_command", command, param1, param2, param3, param4)
	if NetworkAPI.is_client():
		pass
		# Currently multiplayergame is always connected, rpc arrives even locally
#		match_network_execute_command(command, param1, param2, param3, param4)

func send_to_client(command, network_id=null, param2=null, param3=null, param4=null):
	if is_broadcast_command(command) or is_server_command(command):
		Terminal.add_log(Debug.ERROR, Debug.MATCH_NETWORK, "Trying to send unproper command to client!")
		return
	
	if network_id == NetworkAPI.SERVER_ID:
		if NetworkAPI.is_client():
			match_network_execute_command(command, param2, param3, param4)
	else:
		rpc_id(network_id, "match_network_execute_command", command, network_id, param2, param3, param4)

func execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
	match_network_execute_command(cmd, param1, param2, param3, param4)
	
func match_network_execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
	# check rights
	if not command.values().has(cmd):
		Terminal.add_log(Debug.ERROR, Debug.MATCH_NETWORK, "Trying to execute incoming unknown (%d) command!" % cmd)
		return
	if server_commands.has(cmd) and not NetworkAPI.is_host():
		Terminal.add_log(Debug.ERROR, Debug.MATCH_NETWORK, "Trying to execute server command (%s) while being a client!" % command.keys()[cmd])
		return
	Terminal.add_log(Debug.INFO, Debug.MATCH_NETWORK, "Executing command %s!" % command.keys()[cmd])
	
	var network_id = get_tree().get_rpc_sender_id()
	match cmd:
		command.REQUEST_MOVE:
			var unit_ids = mod.Database.pack_unit_ids(param1)
			rpc_id(mod.Network.SERVER_ID, "match_network_execute_command", command.VERIFY_MOVE, unit_ids, param2)
		command.VERIFY_MOVE:
			var unit_list = mod.Database.unpack_unit_ids(param1)
#			var movement = mod.MatchLogic.verify_movement(unit_list, param2)
			#if movement.is_valid():
				# Server-only execute move
#				mod.MatchLogic.make_move(unit_list, param2)
#				execute_command(command.BROADCAST_MOVELIST, unit_list, param2)
#				rpc("match_network_execute_command", command.EXECUTE_MOVE, param1, param2)
			#	pass
			#else:
			#	rpc_id(network_id, "match_network_execute_command", command.DISCARD_MOVE, movement.invalid_reason)
		command.TEST_SEND_MATCH_STATE_HASH:
			var match_state_hash = MatchDataPackage.get_current_hash(mod)
			rpc_id(mod.Network.SERVER_ID, "match_network_execute_command", command.TEST_VERIFY_MATCH_STATE_HASH, match_state_hash)
		command.TEST_VERIFY_MATCH_STATE_HASH:
			var match_state_hash = MatchDataPackage.get_current_hash(mod)
			if match_state_hash != param1:
				Terminal.add_log(Debug.ERROR, Debug.MATCH_NETWORK, "Network match status hash mismatch. %d != %d" % [match_state_hash, param1])
		command.DISCARD_MOVE:
			Terminal.add_log(Debug.INFO, Debug.MATCH_NETWORK, "Server says: invalid move: %s" % ErrorInfo.get_invalid_string_by_enum(param1))
		command.EXECUTE_MOVE:
			var unit_list = mod.Database.unpack_unit_ids(param1)
#			mod.MatchLogic.make_move(unit_list, param2)
		command.BROADCAST_MOVELIST:
			var unit_ids = mod.Database.pack_unit_ids(param1)
			rpc("match_network_execute_command", command.EXECUTE_MOVELIST, unit_ids, param2)
		command.EXECUTE_MOVELIST:
#			mod.MatchLogic.client_execute_move(param1, param2)
			rpc_id(network_id, "match_network_execute_command", command.SEND_MATCH_HASH_STATUS)
		command.SEND_MATCH_HASH_STATUS:
			var update_package = MatchDataPackage.pack_match(mod)
			rpc_id(network_id, "match_network_execute_command", command.SEND_MATCH_HASH_STATUS)
			
		command.UPDATE_TURN_OWNER:
			mod.MatchLogic.set_turn_owner(param1)
			mod.GameUI.update_ui()

		## MATCH STATUS SYNCING

		command.SERVER_CHECK_MATCH_SYNC:
			var match_state_hash = MatchDataPackage.get_current_hash(mod)
			rpc("match_network_execute_command", command.CLIENT_VERIFY_MATCH_SYNC, match_state_hash)
		command.CLIENT_VERIFY_MATCH_SYNC:
			var match_state_hash = MatchDataPackage.get_current_hash(mod)
			if(match_state_hash != param1):
				rpc_id(mod.Network.SERVER_ID, "match_network_execute_command", command.SERVER_SYNC_MATCH_STATUS)
		command.SERVER_SYNC_MATCH_STATUS:
			var packed_status = MatchDataPackage.pack_match(mod)
			rpc_id(network_id, "match_network_execute_command", command.CLIENT_MATCH_STATE_UPDATE, packed_status)
		command.SERVER_BROADCAST_MATCH_STATUS:
			var packed_status = MatchDataPackage.pack_match(mod)
			rpc("match_network_execute_command", command.CLIENT_CONFIRM_SYNC, packed_status)
#		command.CLIENT_CONFIRM_SYNC:
#			if not mod.Network.is_server():
#				mod.MapView.setup_map(param1)
#				execute_command(command.TEST_SEND_MATCH_STATE_HASH)

		## MATCH START/SETUP
		command.UPDATE_MATCH_STATUS:
			mod.ClientData.MatchData.setup(param1)
			mod.ControllerData.update_display()
		command.START_MATCH:
			mod.ClientData.MatchData.start_match(param1)
			mod.ControllerData.update_display()

		## QUEUE SENDING
		command.CLIENT_REQUEST_QUEUE:
			mod.ServerData.CommandData.server_unpack_verify_and_execute_queue(param1)
		command.SERVER_BROADCAST_QUEUE:
			mod.ClientData.CommandData.client_unpack_and_execute_queue(param1)
			
		command.SERVER_DISCARD_QUEUE:
			print("Queue discarded. Reason: %s" % [param1])
