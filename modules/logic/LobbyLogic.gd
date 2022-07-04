class_name LobbyLogic
extends Node

func start_game_setup():
	mod.LobbyNetwork.execute_command(LobbyNetwork.command.BROADCAST_START)
	mod.MatchLogic.determine_next_turn_owner()
	mod.MatchNetwork.execute_command(MatchNetwork.command.BROADCAST_TURN_OWNER)

func get_sorted_players():
	pass
