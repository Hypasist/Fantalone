class_name MatchNetworkAPI
extends Node

enum command { \
	SERVER_CHECK_MATCH_SYNC, \
	CLIENT_VERIFY_MATCH_SYNC, \
	SERVER_SYNC_MATCH_STATUS, \
	SERVER_BROADCAST_MATCH_STATUS, \
	CLIENT_CONFIRM_SYNC, \
	
	
	SERVER_START_MATCH, \
	\
	SERVER_UPDATE_MATCH_STATUS, \
	CLIENT_REQUEST_MATCH_STATUS, \
	\
	CLIENT_REQUEST_QUEUE, \
	SERVER_BROADCAST_QUEUE, \
	SERVER_DISCARD_QUEUE, \
}

const server_commands = [ \
	command.CLIENT_REQUEST_QUEUE, \
]
static func is_server_command(cmd):
	return server_commands.has(cmd)


const broadcast_commands = [ \
	command.SERVER_BROADCAST_QUEUE, \
	command.SERVER_UPDATE_MATCH_STATUS, \
	command.SERVER_START_MATCH, \
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
		# Currently multiplayergame is always connected, rpc arrives even locally
		match_network_execute_command(command, param1, param2, param3, param4)

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

		## MATCH START/SETUP
		command.SERVER_START_MATCH:
			mod.ClientData.MatchData.start_match(param1)
			mod.ControllerData.update_display()
		
		## MATCH STATUS
		command.CLIENT_REQUEST_MATCH_STATUS:
			send_to_client(command.SERVER_UPDATE_MATCH_STATUS, network_id, \
				MatchDataPackage.pack_match(mod.ServerData))
		command.SERVER_UPDATE_MATCH_STATUS:
			mod.ClientData.MatchData.setup(param1)
			mod.ControllerData.update_display()
			
		## QUEUE SENDING
		command.CLIENT_REQUEST_QUEUE:
			mod.ServerData.CommandData.server_unpack_verify_and_execute_queue(param1)
		command.SERVER_BROADCAST_QUEUE:
			mod.ClientData.CommandData.client_unpack_and_execute_queue(param1)
		command.SERVER_DISCARD_QUEUE:
			print("Queue discarded. Reason: %s" % [param1])
