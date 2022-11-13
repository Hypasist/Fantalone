class_name MatchNetwork
extends Node

enum command { \
	BROADCAST_GAMESTATE, \
	BROADCAST_TURN_OWNER, \
	BROADCAST_LOG_CMD, \
	UPDATE_TURN_OWNER, \
	VERIFY_MOVE, \
	BROADCAST_MOVELIST, \
	DISCARD_MOVE, \
	REQUEST_END_TURN, \
	VERIFY_END_TURN, \
	REQUEST_MOVE, \
	EXECUTE_MOVE, \
	EXECUTE_MOVELIST, \
	EXECUTE_LOG_CMD, \
	BROADCAST_COMMAND_LIST, \
	BROADCAST_MATCH_HASH_STATUS_REQUEST, \
	REQUEST_MATCH_HASH_STATUS, \
	SEND_MATCH_HASH_STATUS, \
	VERIFY_MATCH_HASH_STATUS, \
	CONFIRM_MATCH_HASH_STATUS, \
	BROADCAST_MATCH_STATUS, \
	SEND_MATCH_STATUS, \
	TEST_SHARE_MATCH_STATUS, \
	TEST_UPDATE_MATCH_STATUS, \
	TEST_SEND_MATCH_STATE_HASH, \
	TEST_VERIFY_MATCH_STATE_HASH, \
	TEST_REQUEST_COMMAND, \
	TEST_VERIFY_COMMAND, \
	TEST_BROADCAST_COMMAND, \
	TEST_EXECUTE_COMMAND, \
	TEST_DISCARD_COMMAND, \
}

const server_commands = [ \
	command.BROADCAST_GAMESTATE, \
	command.BROADCAST_TURN_OWNER, \
	command.BROADCAST_LOG_CMD, \
	command.BROADCAST_MOVELIST, \
	command.VERIFY_END_TURN, \
	command.VERIFY_MOVE, \
]


func setup():
	rpc_config("match_network_execute_command", MultiplayerAPI.RPC_MODE_SYNC)

func execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
	match_network_execute_command(cmd, param1, param2, param3, param4)
	
func match_network_execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
	# check rights
	if not command.values().has(cmd):
		Terminal.add_log(Debug.ERROR, Debug.NETWORK, "Trying to execute incoming unknown (%d) command!" % cmd)
		return
	if server_commands.has(cmd) and not mod.Network.is_server():
		Terminal.add_log(Debug.ERROR, Debug.NETWORK, "Trying to execute server command (%s) while being a client!" % command.keys()[cmd])
		return
	Terminal.add_log(Debug.INFO, Debug.NETWORK, "Executing command %s!" % command.keys()[cmd])
	
	var network_id = get_tree().get_rpc_sender_id()
	match cmd:
		command.BROADCAST_GAMESTATE:
			pass
		command.REQUEST_MOVE:
			var unit_ids = mod.Database.pack_unit_ids(param1)
			rpc_id(mod.Network.SERVER_ID, "match_network_execute_command", command.VERIFY_MOVE, unit_ids, param2)
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
		command.TEST_SHARE_MATCH_STATUS:
			var packed_status = MatchDataPackage.pack_match()
			rpc("match_network_execute_command", command.TEST_UPDATE_MATCH_STATUS, packed_status)
		command.TEST_UPDATE_MATCH_STATUS:
			if not mod.Network.is_server():
				mod.MapView.setup_map(param1)
				execute_command(command.TEST_SEND_MATCH_STATE_HASH)
		command.TEST_SEND_MATCH_STATE_HASH:
			var match_state_hash = MatchDataPackage.pack_match().hash()
			rpc_id(mod.Network.SERVER_ID, "match_network_execute_command", command.TEST_VERIFY_MATCH_STATE_HASH, match_state_hash)
		command.TEST_VERIFY_MATCH_STATE_HASH:
			var match_state_hash = MatchDataPackage.pack_match().hash()
			if match_state_hash != param1:
				Terminal.add_log(Debug.ERROR, Debug.NETWORK, "Network match status hash mismatch. %d != %d" % [match_state_hash, param1])
		command.DISCARD_MOVE:
			Terminal.add_log(Debug.INFO, Debug.NETWORK, "Server says: invalid move: %s" % ErrorInfo.get_invalid_string_by_enum(param1))
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
			var update_package = MatchDataPackage.pack_match()
			rpc_id(network_id, "match_network_execute_command", command.SEND_MATCH_HASH_STATUS)
		command.TEST_REQUEST_COMMAND:
			rpc_id(mod.Network.SERVER_ID, "match_network_execute_command", command.TEST_VERIFY_COMMAND, param1)
		command.TEST_VERIFY_COMMAND:
			mod.CommandQueue.server_unpack_and_execute_queue(param1)
		command.TEST_BROADCAST_COMMAND:
			rpc("match_network_execute_command", command.TEST_EXECUTE_COMMAND, param1)
		command.TEST_EXECUTE_COMMAND:
			if not mod.Network.is_server():
				mod.CommandQueue.client_unpack_and_execute_queue(param1)
		command.TEST_DISCARD_COMMAND:
			print("DISCARD, ", param1)
		
		command.BROADCAST_LOG_CMD: 
			# Needs to be packed before
			rpc("match_network_execute_command", command.EXECUTE_LOG_CMD, param1)
		command.EXECUTE_LOG_CMD:
			mod.MatchLogic.execute_log_cmd(param1)
			
		command.REQUEST_END_TURN:
			rpc_id(mod.Network.SERVER_ID, "match_network_execute_command", command.VERIFY_END_TURN, param1)
		command.VERIFY_END_TURN:
			var movement = mod.MatchLogic.end_turn(param1)
			if movement.is_valid():
				pass
			else:
				rpc_id(network_id, "match_network_execute_command", command.DISCARD_MOVE, movement.invalid_reason)
		command.BROADCAST_TURN_OWNER:
				rpc("match_network_execute_command", command.UPDATE_TURN_OWNER, mod.MatchLogic.get_turn_owner())
		command.UPDATE_TURN_OWNER:
			mod.MatchLogic.set_turn_owner(param1)
			mod.UI.update_ui()
