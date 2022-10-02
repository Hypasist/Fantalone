class_name Database
extends Node

# GLOBALS ACCESS
func get_color(id):
	return $GameParameters.colorList[id]
func get_colorlist():
	return $GameParameters.colorList
func get_nickname():
	return $GameParameters.player_name
func set_nickname(name):
	$GameParameters.player_name = name
func get_version():
	return $GameParameters.game_version
	
# ACCESS FUNCTIONS:
func is_autofinish_turn():
	return $GameParameters.autofinish_turn
func set_autofinish_turn(value):
	$GameParameters.autofinish_turn = value

func set_resolution(resolution):
	$GameParameters.set_resolution(resolution)
func get_map_resolution():
	return $GameParameters.map_resolution
func get_game_resolution():
	return $GameParameters.game_resolution

func get_tilesize():
	return $GameParameters.get_tilesize()

func get_min_map_scale():
	return $GameParameters.min_map_scale
func get_max_map_scale():
	return $GameParameters.max_map_scale
	
func get_map_bounds_padding():
	return $GameParameters.get_map_bounds_padding()
func get_min_map_boundaries():
	return $MatchParameters.min_map_boundaries
func get_max_map_boundaries():
	return $MatchParameters.max_map_boundaries
func set_min_map_boundaries(value:Vector2):
	$MatchParameters.min_map_boundaries = value
func set_max_map_boundaries(value:Vector2):
	$MatchParameters.max_map_boundaries = value

# MATCH
func get_players_units_num(match_id):
	return $MatchData.get_players_units_num(match_id)
func report_new_object(class_):
	return $MatchData.report_new_object(class_)
func setup_new_match():
	$MatchData.setup_new_match()

# RESOURCES
func get_resource_by_name(name):
	return $ResourceData.get_resource(name)

# PACKING FUNCTIONS
func pack_unit_ids(unit_list):
	var ids = []
	for unit in unit_list:
		ids.append(unit._name_id)
	return ids

func unpack_unit_ids(unit_ids):
	var units = []
	for unit in mod.MatchData.get_all_units():
		if unit_ids.has(unit._name_id):
			units.append(unit)
	return units

func pack_unit(unit):
	return unit._name_id
func unpack_unit(unit_id):
	for unit in mod.MatchData.get_all_units():
		if unit_id == unit._name_id:
			return unit
