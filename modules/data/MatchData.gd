class_name MatchData
extends Node

func pause_game():
	pass

var STARTING_MANA = 8
var player_mana = {}
func setup_match():
	var player_list = mod.LobbyData.get_players()
	for player in player_list:
		player_mana[player.match_id] = STARTING_MANA

func get_player_mana(match_id):
	return player_mana[match_id]
func get_players_mana():
	return player_mana

var item_counter = {}
func get_unique_name(name):
	if item_counter.has(name):
		item_counter[name] = item_counter[name] + 1
	else:
		item_counter[name] = 0
	return "%s_%03d" % [name, item_counter[name]]

var unit_list = []
func register_new_unit(unit_instance):
	unit_list.append(unit_instance)

func get_all_units():
	for unit in unit_list:
		if unit == null:
			breakpoint # NULL !
	return unit_list

func get_players_units(owner_id):
	var return_array = []
	for unit in unit_list:
		if unit == null:
			breakpoint # NULL !
		elif unit.get_owner() == owner_id:
			return_array.append(unit)
	return return_array

func get_players_units_num(match_id):
	var counter = 0
	for unit in unit_list:
		if unit == null:
			breakpoint # NULL !
		elif unit.get_owner() == match_id:
			counter += 1
	return counter

var tile_list = []
func register_new_tile(tile_instance):
	tile_list.append(tile_instance)

func cleanup_objects():
	for i in range(unit_list.size() - 1, -1, -1):
		if unit_list[i].is_marked_to_delete():
			cleanup_unit(unit_list[i])
	for i in range(tile_list.size() - 1, -1, -1):
		if tile_list[i].is_marked_to_delete():
			cleanup_tile(tile_list[i])

func cleanup_all_objects():
	for i in range(unit_list.size() - 1, -1, -1):
		cleanup_unit(unit_list[i])
	for i in range(tile_list.size() - 1, -1, -1):
		cleanup_tile(tile_list[i])

func cleanup_unit(unit):
	Terminal.add_log(Debug.ALL, Debug.MATCH, "Unit %s erased!" % unit.get_name_id())
	unit.get_hex().unit_logic = null
	if unit.display and unit.display.display_deletable():
		unit.display.queue_free()
	unit_list.erase(unit)
	
func cleanup_tile(tile):
	Terminal.add_log(Debug.ALL, Debug.MATCH, "Tile %s erased!" % tile.get_name_id())
	tile.get_hex().unit_logic = null
	if tile.display:
		tile.display.queue_free()
	tile_list.erase(tile)
