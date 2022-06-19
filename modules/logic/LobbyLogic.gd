class_name LobbyLogic
extends Node

func start_game_setup():
	mod.LobbyNetwork.execute_command(LobbyNetwork.command.BROADCAST_START)
	mod.MatchLogic.determine_next_turn_owner()
	mod.MatchNetwork.execute_command(MatchNetwork.command.BROADCAST_TURN_OWNER)

func get_my_id():
	var network_id = mod.Network.get_id()
	var member = mod.LobbyData.LobbyMemberInfo_dict[network_id]
	return member.match_id

func is_match_id_mine(match_id):
	var match_players = mod.LobbyData.get_players()
	for player in match_players:
		if player.match_id == match_id:
			if player.owner_lobby_member.network_id == mod.Network.get_id():
				return true
	return false
	#var lobby_member = mod.LobbyData.LobbyMemberInfo_dict[mod.Network.get_id()]

func end_match():
	print("EXIT THE MATCH")
	pass
