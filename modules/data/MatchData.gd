class_name MatchData
extends Node

func pause_game():
	pass
	
func setup_match():
	var player_list = mod.LobbyData.get_players()
	for player in player_list:
		player_mana[player.match_id] = STARTING_MANA

## MANA

var STARTING_MANA = 8
var player_mana = {}
func get_player_mana(match_id):
	return player_mana[match_id]
func get_players_mana():
	return player_mana

## UNITS

func get_all_units():
	var return_array = []
	for unit in mod.ObjectData.get_unit_list():
		if not unit.is_marked_to_delete():
			return_array.append(unit)
	return return_array

func get_players_units(match_id):
	var return_array = []
	for unit in get_all_units():
		if unit.get_owner() == match_id:
			return_array.append(unit)
	return return_array

func get_players_units_num(match_id):
	return get_players_units(match_id).size()

## Tiles

func get_all_tiles():
	var return_array = []
	for tile in mod.ObjectData.get_tile_list():
		if not tile.is_marked_to_delete():
			return_array.append(tile)
	return return_array

## Garbage collector 

func cleanup_marked_objects():
	var unit_marked_list = []
	for unit in mod.ObjectData.get_unit_list():
		if unit.is_marked_to_delete():
			unit_marked_list.append(unit)
	mod.ObjectData.remove_unit_list(unit_marked_list)
	
	var tile_marked_list = []
	for tile in mod.ObjectData.get_tile_list():
		if tile.is_marked_to_delete():
			tile_marked_list.append(tile)
	mod.ObjectData.remove_tile_list(tile_marked_list)
