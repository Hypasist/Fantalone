class_name LobbyNetwork
extends Node

enum command { \
	BROADCAST_LOBBY, \
	BROADCAST_START, \
	UPDATE_LOBBY, \
	START_GAME, \
	COLOR_CHANGE, \
	NAME_CHANGE, \
	IDENTIFY_YOURSELF, \
	NEW_LOBBY_MEMBER, \
	NEW_MATCH_MEMBER, \
	REMOVE_MEMBER, \
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

const server_commands = [ \
	command.BROADCAST_LOBBY, \
	command.BROADCAST_START, \
	command.NEW_LOBBY_MEMBER, \
	command.NEW_MATCH_MEMBER, \
	command.REMOVE_MEMBER, \
	command.LEAVE, \
	command.NAME_CHANGE, \
	command.COLOR_CHANGE, \
	command.REQUEST_IDENTIFICATION, \
	command.REQUEST_LOBBY_HASH_STATUS, \
	command.VERIFY_LOBBY_HASH_STATUS, \
]

const refresh_lobby_commands = [
	command.BROADCAST_LOBBY, \
	command.COLOR_CHANGE, \
	command.NAME_CHANGE, \
	command.NEW_LOBBY_MEMBER, \
	command.NEW_MATCH_MEMBER, \
	command.REMOVE_MEMBER, \
	command.LEAVE, \
]

func setup():
	rpc_config("lobby_network_execute_command", MultiplayerAPI.RPC_MODE_SYNC)

func execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
	lobby_network_execute_command(cmd, param1, param2, param3, param4)

func lobby_network_execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
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
		command.BROADCAST_START:
			rpc("lobby_network_execute_command", command.START_GAME)
		command.START_GAME:
			mod.MatchLogic.start_match()
		command.REQUEST_IDENTIFICATION: # param1 = identification_target
			rpc_id(param1, "lobby_network_execute_command", command.IDENTIFY_YOURSELF)
		command.IDENTIFY_YOURSELF:
			var nickname = mod.Database.get_nickname()
			var version = mod.Database.get_version()
			rpc_id(Network.SERVER_ID, "lobby_network_execute_command", command.NEW_LOBBY_MEMBER, nickname, version)
		command.NEW_LOBBY_MEMBER: # param1 = nickname
			mod.LobbyData.new_lobby_member(network_id, param1, param2)
		command.REQUEST_NEW_MEMBER: # param1 = match_id; param2 = player_type; 
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.NEW_MATCH_MEMBER, param1, param2)
		command.NEW_MATCH_MEMBER: # param1 = match_id; param2 = player_type;
			var nickname = mod.LobbyData.LobbyMemberInfo_dict[network_id].nickname
			mod.LobbyData.add_player(network_id, param1, nickname, param2)

		command.REQUEST_REMOVE: # param1 = unique_id;
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.REMOVE_MEMBER, param1)
		command.REMOVE_MEMBER: # param1 = unique_id;
			mod.LobbyData.remove_match_member(param1)

		command.REQUEST_NAME_CHANGE: # param1 = unique_id; param2 = new_name
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.NAME_CHANGE, param1, param2)
		command.NAME_CHANGE:
			mod.LobbyData.change_player_name_by_unique_id(param1, param2)
			
		command.REQUEST_COLOR_CHANGE: # param1 = unique_id; param2 = left_right_value
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.COLOR_CHANGE, param1, param2)
		command.COLOR_CHANGE:
			mod.LobbyData.change_player_color(param1, param2)
		
		command.REQUEST_UPDATE_LOBBY:
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.BROADCAST_LOBBY)
		command.UPDATE_LOBBY:
			mod.LobbyData.setup(param1)
			mod.Menu.refresh()
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

	# BROADCAST_LOBBY to every member after certain commands 
	if refresh_lobby_commands.has(cmd) and mod.Network.is_server():
		var update_package = LobbyDataPackage.pack(mod.LobbyData)
		rpc("lobby_network_execute_command", command.UPDATE_LOBBY, update_package)
		rpc("lobby_network_execute_command", command.REQUEST_LOBBY_HASH_STATUS)
