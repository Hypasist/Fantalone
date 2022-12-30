class_name MatchNetwork
extends Node

enum command { \
	BROADCAST_MOVELIST, \
	DISCARD_MOVE, \
	REQUEST_END_TURN, \
	VERIFY_END_TURN, \
	EXECUTE_MOVE, \
	EXECUTE_MOVELIST, \
	BROADCAST_COMMAND_LIST, \
	BROADCAST_MATCH_HASH_STATUS_REQUEST, \
	REQUEST_MATCH_HASH_STATUS, \
	SEND_MATCH_HASH_STATUS, \
	
	TEST_SHARE_MATCH_STATUS, \
	TEST_UPDATE_MATCH_STATUS, \
	TEST_SEND_MATCH_STATE_HASH, \
	TEST_VERIFY_MATCH_STATE_HASH, \
	
	SERVER_CHECK_MATCH_SYNC, \
	CLIENT_VERIFY_MATCH_SYNC, \
	SERVER_SYNC_MATCH_STATUS, \
	SERVER_BROADCAST_MATCH_STATUS, \
	CLIENT_CONFIRM_SYNC, \
	SERVER_PROCEED_TURN, \
	
	CLIENT_REQUEST_QUEUE, \
	SERVER_VERIFY_QUEUE, \
	SERVER_BROADCAST_QUEUE, \
	CLIENT_EXECUTE_QUEUE, \
	SERVER_DISCARD_QUEUE, \

	# OUT
	VERIFY_MOVE
}

const server_commands = [ \
	command.BROADCAST_MOVELIST, \
	command.VERIFY_END_TURN, \
]


func setup():
	rpc_config("match_network_execute_command", MultiplayerAPI.RPC_MODE_SYNC)

func execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
	match_network_execute_command(cmd, param1, param2, param3, param4)
	
func match_network_execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
	# check rights
	if not command.values().has(cmd):
		Terminal.add_log(Debug.ERROR, Debug.MATCH_NETWORK, "Trying to execute incoming unknown (%d) command!" % cmd)
		return
	if server_commands.has(cmd) and not mod.Network.is_server():
		Terminal.add_log(Debug.ERROR, Debug.MATCH_NETWORK, "Trying to execute server command (%s) while being a client!" % command.keys()[cmd])
		return
	Terminal.add_log(Debug.INFO, Debug.MATCH_NETWORK, "Executing command %s!" % command.keys()[cmd])
	
	var network_id = get_tree().get_rpc_sender_id()
	match cmd:
		command.VERIFY_MOVE:
			var unit_list = mod.Database.unpack_unit_ids(param1)
			var movement = mod.MatchLogic.verify_movement(unit_list, param2)
			if movement.is_valid():
				# Server-only execute move
#				mod.MatchLogic.make_move(unit_list, param2)
				execute_command(command.TEST_SHARE_MATCH_STATUS)
#				execute_command(command.BROADCAST_MOVELIST, unit_list, param2)
#				rpc("match_network_execute_command", command.EXECUTE_MOVE, param1, param2)
			else:
				rpc_id(network_id, "match_network_execute_command", command.DISCARD_MOVE, movement.invalid_reason)
		command.TEST_SEND_MATCH_STATE_HASH:
			var match_state_hash = MatchDataPackage.get_current_hash()
			rpc_id(mod.Network.SERVER_ID, "match_network_execute_command", command.TEST_VERIFY_MATCH_STATE_HASH, match_state_hash)
		command.TEST_VERIFY_MATCH_STATE_HASH:
			var match_state_hash = MatchDataPackage.get_current_hash()
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
			var update_package = MatchDataPackage.pack_hash_match()
			rpc_id(network_id, "match_network_execute_command", command.SEND_MATCH_HASH_STATUS)
			
		command.REQUEST_END_TURN:
			rpc_id(mod.Network.SERVER_ID, "match_network_execute_command", command.VERIFY_END_TURN, param1)
		command.VERIFY_END_TURN:
			var movement = mod.MatchLogic.end_turn(param1)
			if movement.is_valid():
				pass
			else:
				rpc_id(network_id, "match_network_execute_command", command.DISCARD_MOVE, movement.invalid_reason)

		## MATCH STATUS SYNCING

		command.SERVER_CHECK_MATCH_SYNC:
			var match_state_hash = MatchDataPackage.get_current_hash()
			rpc("match_network_execute_command", command.CLIENT_VERIFY_MATCH_SYNC, match_state_hash)
		command.CLIENT_VERIFY_MATCH_SYNC:
			var match_state_hash = MatchDataPackage.get_current_hash()
			if(match_state_hash != param1):
				rpc_id(Network.SERVER_ID, "match_network_execute_command", command.SERVER_SYNC_MATCH_STATUS)
		command.SERVER_SYNC_MATCH_STATUS:
			var packed_hash_status = MatchDataPackage.pack_hash_match()
			rpc_id(network_id, "match_network_execute_command", command.CLIENT_MATCH_STATE_UPDATE, packed_hash_status)
		command.SERVER_BROADCAST_MATCH_STATUS:
			mod.MatchLogic.set_server_lock(true)
			var packed_hash_status = MatchDataPackage.pack_hash_match()
			rpc("match_network_execute_command", command.CLIENT_CONFIRM_SYNC, packed_hash_status)
		command.CLIENT_CONFIRM_SYNC:
			# Server already has this status
			if not mod.Network.is_server():
				MatchDataPackage.unpack_hash_match(param1)
			# Turn owner poked, inform the server
			if mod.LocalLogic.is_turn_owner_locally_present():
				rpc("match_network_execute_command", command.SERVER_PROCEED_TURN) 
		command.SERVER_PROCEED_TURN:
			mod.MatchLogic.set_server_lock(false)
		
		
		## QUEUE SENDING
		
		command.CLIENT_REQUEST_QUEUE:
			rpc_id(mod.Network.SERVER_ID, "match_network_execute_command", command.SERVER_VERIFY_QUEUE, param1)
		command.SERVER_VERIFY_QUEUE:
			mod.CommandQueue.server_unpack_and_execute_queue(param1)
		command.SERVER_BROADCAST_QUEUE:
			rpc("match_network_execute_command", command.CLIENT_EXECUTE_QUEUE, param1)
		command.CLIENT_EXECUTE_QUEUE:
			mod.CommandQueue.client_unpack_and_execute_queue(param1)
		command.SERVER_DISCARD_QUEUE:
			print("DISCARD, ", param1)
		
