extends Node

var players_number = 0
var players_info = []
var current_turn_owner = null

func clear_players_info():
	players_number = 0
	players_info = []

func add_player_info(id:int, network_id:int, nickname_:String, color:Color, type=LobbyMemberInfo.TYPE_PLAYER, player_type_=LobbyMemberInfo.HUMAN_PLAYER):
	var new_member = LobbyMemberInfo.new()
	new_member.setup(id, network_id, type, nickname_, color, player_type_)
	players_info.append(new_member)
	players_number += 1

func get_player_info_by_id(id):
	for info in players_info:
		if info.id == id:
			return info
func get_player_info_by_network_id(network_id):
	for info in players_info:
		if info.network_id == network_id:
			return info

var min_map_boundaries = Vector2(-100, -100)
var max_map_boundaries = Vector2(1124, 700)
