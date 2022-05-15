class_name LobbyNetwork
extends Node

enum command { \
	BROADCAST_LOBBY, \
	BROADCAST_START, \
	START_GAME, \
	COLOR_CHANGE, \
	NAME_CHANGE, \
	NEW_MEMBER, \
	NEW_BOT, \
	JOIN, \
	LEAVE, \
	OBSERVE, \
	UPDATE_LOBBY, \
	REQUEST_IDENTIFICATION, \
	REQUEST_UPDATE_LOBBY, \
	REQUEST_NAME_CHANGE, \
	REQUEST_COLOR_CHANGE, \
	REQUEST_NEW_MEMBER \
}

const server_commands = [ \
	command.BROADCAST_LOBBY, \
	command.BROADCAST_START, \
	command.NEW_BOT, \
	command.NEW_MEMBER, \
	command.JOIN, \
	command.LEAVE, \
	command.OBSERVE, \
	command.NAME_CHANGE, \
	command.COLOR_CHANGE, \
	command.REQUEST_IDENTIFICATION \
]

const refresh_lobby_commands = [
	command.BROADCAST_LOBBY, \
	command.COLOR_CHANGE, \
	command.NAME_CHANGE, \
	command.NEW_BOT, \
	command.NEW_MEMBER, \
	command.JOIN, \
	command.LEAVE, \
	command.OBSERVE \
]

func setup():
	rpc_config("lobby_network_execute_command", MultiplayerAPI.RPC_MODE_SYNC)

func execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
	lobby_network_execute_command(cmd, param1, param2, param3, param4)

func lobby_network_execute_command(cmd, param1=null, param2=null, param3=null, param4=null):
	# check rights
	if not command.values().has(cmd):
		Terminal.add_log(Terminal.ERROR, "Trying to execute incoming unknown (%d) command!" % cmd)
		return
	if server_commands.has(cmd) and not mod.Network.is_server():
		Terminal.add_log(Terminal.ERROR, "Trying to execute server command (%s) while being a client!" % command.keys()[cmd])
		return
	Terminal.add_log(Terminal.INFO, "Executing command %s!" % command.keys()[cmd])
	
	var network_id = get_tree().get_rpc_sender_id()
	match cmd:
		command.BROADCAST_LOBBY:
			pass
		command.BROADCAST_START:
			rpc("lobby_network_execute_command", command.START_GAME)
		command.START_GAME:
			mod.MatchLogic.start_match()
		command.REQUEST_IDENTIFICATION:
			rpc_id(param1, "lobby_network_execute_command", command.REQUEST_NEW_MEMBER)
		command.REQUEST_NEW_MEMBER:
			var player_name = mod.Database.get_player_name()
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.NEW_MEMBER, player_name)
		command.NEW_MEMBER:
			mod.LobbyData.add_update_member(network_id, LobbyMemberInfo.TYPE_PLAYER, LobbyMemberInfo.HUMAN_PLAYER, param1)
		command.NEW_BOT:
			mod.LobbyData.add_update_member(network_id, LobbyMemberInfo.TYPE_PLAYER, LobbyMemberInfo.CPU_PLAYER, param1)

		command.REQUEST_NAME_CHANGE:
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.NAME_CHANGE, param1)
		command.NAME_CHANGE:
			mod.LobbyData.change_player_name_by_network_id(network_id, param1)
			
		command.REQUEST_COLOR_CHANGE:
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.COLOR_CHANGE, param1)
		command.COLOR_CHANGE:
			var member = mod.LobbyData.get_member_by_network_id(network_id)
			mod.LobbyData.change_player_color(member.id, param1)
		
		command.REQUEST_UPDATE_LOBBY:
			rpc_id(mod.Network.SERVER_ID, "lobby_network_execute_command", command.UPDATE_LOBBY)
		command.UPDATE_LOBBY:
			mod.LobbyData.setup(param1)
			mod.Menu.refresh()

		command.REQUEST_JOIN, command.JOIN, command.REQUEST_OBSERVE, command.OBSERVE:
			pass

	# broadcast lobby to every member after certain commands 
	if refresh_lobby_commands.has(cmd) and mod.Network.is_server():
		var update_package = LobbyMemberInfoPackage.pack(mod.LobbyData)
		rpc("lobby_network_execute_command", command.UPDATE_LOBBY, update_package)
