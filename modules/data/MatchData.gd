class_name MatchData
extends Node

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
	for unit in unit_list:
		if unit.is_marked_to_delete():
			print(unit.get_name_id() + " erased")
			unit.get_hex().unitLogic = null
			unit_list.erase(unit)
			#unit.get_display_scene().queue_free()
	for tile in tile_list:
		if tile.is_marked_to_delete():
			print(tile.get_name_id() + " erased")
			tile.get_hex().unitLogic = null
			tile_list.erase(tile)
			#tile.get_display_scene().queue_free()
