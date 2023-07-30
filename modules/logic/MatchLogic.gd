class_name MatchLogic
extends Node

static func determine_next_turn_owner(Data):
	var lobby_players = Data.LobbyData.get_players()
	var map_size = Data.LobbyData.get_map_player_size()
	var MatchData = Data.MatchData
	
	if not lobby_players.empty():
		if MatchData.current_turn_owner == -1:
			for i in map_size:
				for player in lobby_players:
					if player.match_id == i and get_players_units(Data, player.match_id).size() > 0:
						return MatchData.set_turn_owner(player.match_id)
		else:
			for i in map_size:
				var candidate = (MatchData.current_turn_owner + i + 1) % map_size
				for player in lobby_players:
					if player.match_id == candidate and get_players_units(Data, player.match_id).size() > 0:
						return MatchData.set_turn_owner(player.match_id)

## Both

static func get_object_by_name(Data, object_name):
	var object = get_unit_by_name(Data, object_name)
	if null == object:
		object = get_tile_by_name(Data, object_name)
	return object


## UNIT SELECTION

static func get_all_units(Data):
	var return_array = []
	for unit in Data.ObjectData.get_unit_list():
		if not unit.is_marked_to_delete():
			return_array.append(unit)
	return return_array

static func get_players_units(Data, match_id):
	var return_array = []
	for unit in get_all_units(Data):
		if unit.get_owner() == match_id:
			return_array.append(unit)
	return return_array

static func get_players_army_size(matchdata, match_id):
	var army_size = 0
	var units = get_players_units(matchdata, match_id)
	for unit in units:
		if unit.has_tags([TagList.SCORE_UNIT]):
			army_size += 1
	return army_size

static func get_unit_by_name(Data, unit_name):
	for unit in get_all_units(Data):
		if unit.get_name_id() == unit_name:
			return unit
	return null

## TILES SELECTION

static func get_all_tiles(matchdata):
	var return_array = []
	for tile in matchdata.ObjectData.get_tile_list():
		if not tile.is_marked_to_delete():
			return_array.append(tile)
	return return_array

static func get_tile_by_name(Data, tile_name):
	for tile in get_all_tiles(Data):
		if tile.get_name_id() == tile_name:
			return tile
	return null

static func get_neighbour_hex(matchdata, hex, direction):
	var hex_dictionary = matchdata.ObjectData.get_hex_dictionary()
	return HexMath.get_neighbour_hex(hex_dictionary, hex, direction)

## -------- PACKING FUNCTIONS -------- ##
static func pack_object_ids(object_list):
	var ids = []
	for unit in object_list:
		ids.append(unit._name_id)
	return ids

static func unpack_object_ids(Data, object_ids):
	var objects = []
	for unit in Data.MatchData.get_all_units():
		if object_ids.has(unit._name_id):
			objects.append(unit)
	for tile in Data.MatchData.get_all_tiles():
		if object_ids.has(tile._name_id):
			objects.append(tile)
	return objects
