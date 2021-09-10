class_name Options
extends Node

enum control { HUMAN_1, HUMAN_2, AI }

var game_options = {
	}
	
var match_options = {
	"player_num" : 4,
	"players" : [ {
		"name" : "Uszatek",
		"color" : Color.blueviolet,
		"control" : control.HUMAN_1
		} , {
		"name" : "Gerubase",
		"color" : Color.webmaroon,
		"control" : control.HUMAN_2
		} ]
	}