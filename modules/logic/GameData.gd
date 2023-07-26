class_name GameData
extends Node

const MAX_PLAYERS = 8

### VARIOUS CONSTANTS
const game_version = "0.3.0.0"
func get_version():
	return game_version

const MAX_PLAYER_NUM = 8
const color_list = [ Color.steelblue, Color.webmaroon, Color.coral, Color.darkgreen ]
const color_name_list = ["Blue", "Red", "Orange", "Green"]

func get_color(id):
	return color_list[id]
func get_color_name_by_color(color):
	for i in color_list.size():
		if color_list[i] == color:
			return color_name_list[i]
	return "Undefined"
func get_color_list():
	return color_list
