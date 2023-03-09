class_name GameData
extends Node

const MAX_PLAYERS = 8

### VARIOUS CONSTANTS
const game_version = "0.2.3"
func get_version():
	return game_version

const MAX_PLAYER_NUM = 8
const color_list = [ Color.steelblue, Color.webmaroon, Color.coral, Color.darkgreen ]
func get_color(id):
	return color_list[id]
func get_color_list():
	return color_list
