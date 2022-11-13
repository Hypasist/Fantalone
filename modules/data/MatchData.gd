class_name MatchData
extends Node

func pause_game():
	pass
	
func setup_match():
	var player_list = mod.LobbyData.get_players()
	for player in player_list:
		player_mana[player.match_id] = STARTING_MANA
	for player in player_list:
		player_max_actions[player.match_id] = MAXIMUM_ACTION_LIMIT

## MANA

var MAXIMUM_MANA_LIMIT = 20
var MANA_REGEN = 20
var STARTING_MANA = 8
var player_mana = {}
func get_player_mana(match_id):
	return player_mana[match_id] if player_mana.has(match_id) else 0
func get_players_mana():
	return player_mana
func modify_player_mana(match_id, mana_cost):
	if player_mana.has(match_id): player_mana[match_id] += mana_cost
func set_players_mana(package):
	player_mana = package

## ACTIONS

var MAXIMUM_ACTION_LIMIT = 3
var player_max_actions = {}
func get_player_max_actions(match_id):
	return player_max_actions[match_id] if player_max_actions.has(match_id) else 0

## EFFECTS

# players effect

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

func get_unit_by_name(unit_name):
	for unit in get_all_units():
		if unit.get_name_id() == unit_name:
			return unit
	return null

## Tiles

func get_all_tiles():
	var return_array = []
	for tile in mod.ObjectData.get_tile_list():
		if not tile.is_marked_to_delete():
			return_array.append(tile)
	return return_array

func get_tile_by_name(tile_name):
	for tile in get_all_tiles():
		if tile.get_name_id() == tile_name:
			return tile
	return null

## Both

func get_object_by_name(object_name):
	var object = get_unit_by_name(object_name)
	if null == object:
		object = get_tile_by_name(object_name)
	return object

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
