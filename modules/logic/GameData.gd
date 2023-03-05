class_name GameData
extends Node


### VARIOUS CONSTANTS
const game_version = "0.2.2"
func get_version():
	return game_version

const MAX_PLAYER_NUM = 8
const color_list = [ Color.steelblue, Color.webmaroon, Color.coral, Color.darkgreen ]
func get_color(id):
	return color_list[id]
func get_color_list():
	return color_list
