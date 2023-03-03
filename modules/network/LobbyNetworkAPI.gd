class_name LobbyNetworkAPI
extends Node

enum command { \
	CLIENT_IDENTIFICATION, \
	UPDATE_LOBBY_STATUS, \
	COLOR_CHANGE, \
	NAME_CHANGE, \
	NEW_MATCH_MEMBER, \
	REMOVE_MATCH_MEMBER, \
	START_GAME, \
\
\
	BROADCAST_LOBBY, \
	BROADCAST_START, \
	UPDATE_LOBBY, \
	IDENTIFY_YOURSELF, \
	NEW_LOBBY_MEMBER, \
	LEAVE, \
	REQUEST_IDENTIFICATION, \
	REQUEST_UPDATE_LOBBY, \
	REQUEST_NAME_CHANGE, \
	REQUEST_COLOR_CHANGE, \
	REQUEST_NEW_MEMBER, \
	REQUEST_REMOVE, \
	BROADCAST_LOBBY_HASH_STATUS_REQUEST, \
	REQUEST_LOBBY_STATUS, \
	REQUEST_LOBBY_HASH_STATUS, \
	SEND_LOBBY_HASH_STATUS, \
	VERIFY_LOBBY_HASH_STATUS, \
	SEND_LOBBY_STATUS, \
}

const client_commands = [
	
]

const server_commands = [ \
	command.CLIENT_IDENTIFICATION, \
	command.NAME_CHANGE, \
	command.COLOR_CHANGE, \
	command.NEW_MATCH_MEMBER, \
	command.REMOVE_MATCH_MEMBER, \
	command.START_GAME, \
\
	command.BROADCAST_LOBBY, \
	command.BROADCAST_START, \
	command.NEW_LOBBY_MEMBER, \
	command.LEAVE, \
	command.REQUEST_IDENTIFICATION, \
	command.REQUEST_LOBBY_HASH_STATUS, \
	command.VERIFY_LOBBY_HASH_STATUS, \
]
static func is_server_command(cmd):
	return server_commands.has(cmd)

const broadcast_commands = [ \
	command.UPDATE_LOBBY_STATUS, \
]

static func is_broadcast_command(cmd):
	return broadcast_commands.has(cmd)

const refresh_lobby_commands = [
	command.CLIENT_IDENTIFICATION, \
	command.COLOR_CHANGE, \
	command.NAME_CHANGE, \
	command.NEW_MATCH_MEMBER, \
	command.REMOVE_MATCH_MEMBER, \
	\
	command.LEAVE, \
]

func setup():
	rpc_config("lobby_network_execute_command", MultiplayerAPI.RPC_MODE_SYNC)

func send_to_server(command, param1=null, param2=null, param3=null, param4=null):
	if is_broadcast_command(command) or not is_server_command(command):
		Terminal.add_log(Debug.ERROR, Debug.LOBBY_NETWORK, "Trying to send unproper command to server!")
		return
	
	if NetworkAPI.is_host():
		lobby_network_execute_command(command, param1, param2, param3, param4)
	else:
		rpc_id(NetworkAPI.SERVER_ID, "lobby_network_execute_command", command, param1, param2, param3, param4)

func broadcast_to_clients(command, param1=null, param2=null, param3=null, param4=null):
	if not is_broadcast_command(command) or is_server_command(command):
		Terminal.add_log(Debug.ERROR, Debug.LOBBY_NETWORK, "Trying to broadcast unproper command!")
		return
	
	rpc("lobby_network_execute_command", command, param1, param2, param3, param4)
	if NetworkAPI.is_client():
		pass
		# Currently multiplayergame is always connected, rpc arrives even locally
#		lobby_network_execute_command(command, param1, param2, param3, param4)
	

func send_to_client(command, network_id=null, param2=null, param3=null, param4=null):
	if is_broadcast_command(command) or is_server_command(command):
		Terminal.add_log(Debug.ERROR, Debug.LOBBY_NETWORK, "Trying to send unproper command to client!")
		return
	
	if network_id == NetworkAPI.SERVER_ID:
		if NetworkAPI.is_client():
			lobby_network_execute_command(command, network_id, param2, param3, param4)
	else:
		rpc_id(network_id, "lobby_network_execute_command", command, network_id, param2, param3, param4)


func lobby_network_execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
	# check rights
	if not command.values().has(cmd):
		Terminal.add_log(Debug.ERROR, Debug.LOBBY_NETWORK, "Trying to execute incoming unknown (%d) command!" % cmd)
		return
	if server_commands.has(cmd) and not NetworkAPI.is_host():
		Terminal.add_log(Debug.ERROR, Debug.LOBBY_NETWORK, "Trying to execute server command (%s) while being a client!" % command.keys()[cmd])
		return
	Terminal.add_log(Debug.INFO, Debug.LOBBY_NETWORK, "Executing command %s!" % command.keys()[cmd])
	
	var network_id = get_tree().get_rpc_sender_id()
	match cmd:
		command.CLIENT_IDENTIFICATION:
			mod.ServerData.LobbyData.new_lobby_member(param1, param2, param3)
		command.COLOR_CHANGE: # param1 = unique_id; param2 = left_right_value
			mod.ServerData.LobbyData.change_player_color(param1, param2)
		command.NAME_CHANGE: # param1 = unique_id; param2 = new_name
			mod.ServerData.LobbyData.change_player_name_by_unique_id(param1, param2)
		command.NEW_MATCH_MEMBER: # param1 = match_id; param2 = player_type;
			mod.ServerData.LobbyData.add_player(param1, param2, param3)
		command.REMOVE_MATCH_MEMBER: # param1 = unique_id;
			mod.ServerData.LobbyData.remove_match_member(param1)
			
		command.START_GAME:
			mod.ServerData.MatchData.start_match()
			
		command.UPDATE_LOBBY_STATUS:
			mod.ClientData.LobbyData.setup(param1)
			mod.Menu.refresh()
		
		command.BROADCAST_START:
			rpc("lobby_network_execute_command", command.START_GAME)
		command.REQUEST_IDENTIFICATION: # param1 = identification_target
			rpc_id(param1, "lobby_network_execute_command", command.IDENTIFY_YOURSELF)
		command.IDENTIFY_YOURSELF:
			var nickname = mod.Database.get_nickname()
			var version = mod.Database.get_version()
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.NEW_LOBBY_MEMBER, nickname, version)
		command.REQUEST_NEW_MEMBER: # param1 = match_id; param2 = player_type; 
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.NEW_MATCH_MEMBER, param1, param2)

		command.REQUEST_REMOVE: # param1 = unique_id;
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.REMOVE_MEMBER, param1)

			
		
		command.REQUEST_UPDATE_LOBBY:
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.BROADCAST_LOBBY)
		command.BROADCAST_LOBBY:
			pass
#			var update_package = LobbyDataPackage.pack(mod.LobbyData)
#			rpc("lobby_network_execute_command", command.UPDATE_LOBBY, update_package)
		command.BROADCAST_LOBBY_HASH_STATUS_REQUEST:
			rpc_id(network_id, "lobby_network_execute_command", command.SEND_LOBBY_HASH_STATUS)
		command.REQUEST_LOBBY_STATUS:
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.REQUEST_LOBBY_HASH_STATUS)
		command.REQUEST_LOBBY_HASH_STATUS:
			var update_package = LobbyDataPackage.pack(mod.LobbyData)
			rpc_id(network_id, "lobby_network_execute_command", command.SEND_LOBBY_HASH_STATUS)
		command.SEND_LOBBY_HASH_STATUS:
			pass
		command.VERIFY_LOBBY_HASH_STATUS:
			pass
		command.SEND_LOBBY_STATUS:
			pass

	# UPDATE LOBBY STATUS to every member after certain commands 
	if refresh_lobby_commands.has(cmd):
		broadcast_to_clients(command.UPDATE_LOBBY_STATUS, LobbyDataPackage.pack(mod.ServerData.LobbyData))


