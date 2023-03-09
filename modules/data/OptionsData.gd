class_name OptionsData
extends Node

### PLAYERS SETTINGS
var autofinish_turn = true
func set_autofinish_turn(value):
	autofinish_turn = value
func is_autofinish_turn():
	return autofinish_turn

### PLAYER PRIVATE SETTINGS
var player_name = "My name"
func get_player_name():
	return player_name
func set_player_name(new_name):
	player_name = new_name
