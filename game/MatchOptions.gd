class_name MatchOptions
extends Node

enum control { HUMAN_1, HUMAN_2, AI }

var match_options = {
	"player_num" : 4,
	"players" : {
		0:{ "name" : "Uszatek",
			"unit_group_name" : "player0units",
			"color" : Color.blueviolet,
			"control" : control.HUMAN_1
			},
		1:{ "name" : "Gerubase",
			"unit_group_name" : "player1units",
			"color" : Color.webmaroon,
			"control" : control.HUMAN_2
			}},
	"map_boundaries" : {
		"left" : -100,
		"top" : -100,
		"right" : 1124,
		"bottom" : 700
	}
}

func clear_player_options():
	match_options["player_num"] = 0
	match_options["players"] = {}
	
func add_player(_id, _name, _color, _control):
	match_options["players"][_id] = {
		"name" : _name,
		"unit_group_name" : str("player", _id, "units"),
		"color" : _color,
		"control" : _control
		}
	match_options["player_num"] += 1