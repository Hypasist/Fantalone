class_name LobbyLogic
extends Node

func start_game_setup():
	mod.LobbyNetwork.execute_command(LobbyNetwork.command.BROADCAST_START)
	mod.MatchLogic.determine_next_turn_owner()
	mod.MatchNetwork.execute_command(MatchNetwork.command.BROADCAST_TURN_OWNER)

func get_my_id():
	var network_id = mod.Network.get_id()
	var member = mod.LobbyData.get_member_by_network_id(network_id)
	return member.id

func get_id_via_network_id(network_id):
	var member = mod.LobbyData.get_member_by_network_id(network_id)
	return member.id

func end_match():
	print("EXIT THE MATCH")
	pass
