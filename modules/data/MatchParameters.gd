extends Node

enum control_enum { HUMAN_1, HUMAN_2, AI }
class PlayerInfo:
	var id : int
	var name_: String
	var group_name: String
	var color : Color
	var control
	
	func _init(id_:int, name__:String, color_:Color, control_):
		id = id_
		name_ = name__
		group_name = str("group_", id)
		color = color_
		control = control_
		return self

var players_number = 0
var players_info = []

func clear_players_info():
	players_number = 0
	players_info = []

func add_player_info(id:int, name_:String, color:Color, control=control_enum.HUMAN_1):
	var info = PlayerInfo.new(id, name_, color, control)
	players_info.append(info)
	players_number += 1

func get_player_info(id):
	for info in players_info:
		if info.id == id:
			return info

var min_map_boundaries = Vector2(-100, -100)
var max_map_boundaries = Vector2(1124, 700)
